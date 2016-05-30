require 'httparty'
require 'json'
require 'yaml'
require 'pp'

class SchedulesController < ApplicationController
	before_filter :authenticate_user!

	layout 'new_layout'
	
	def index
		

		# ==== Start: Get Params And Make Necessary Time Variables
		# 
		#   Time Variables suffixed with _t are used for moment js: e.g. 2016-05-25 22:00:00
		#   Time Variables without suffix are used for HTTP request: e.g. 2016-05-25%2022%3A00
		if not params[:utc_offset].blank?
			@utc_offset = params[:utc_offset].to_i
		end

		if not params[:utc_locale].blank?
			@utc_offset = params[:utc_locale].to_i
		end

		if not params[:now].blank? 
			@now = params[:now]
			@start = Time.parse(@now).change(:hour => 0, :min => 0, :sec => 0)
		end

		if not params[:cur_now].blank? 
			@now = params[:cur_now]
			@start = Time.parse(@now).change(:hour => 0, :min => 0, :sec => 0)
		end
		
		
		@select_time_val = '00';
		@start_t = @start
		@start = Listing.format_time @start

		if not params[:listings_date_picker_date_select].blank? 
			@search_date = Time.parse(params[:listings_date_picker_date_select])
		else
			@search_date = @start_t
		end

		if not params[:listings_date_picker_time_select].blank?
			if params[:listings_date_picker_time_select].eql? "now"
				@search_time = @search_date.change(:hour => Time.parse(@now).hour, :min => 0, :sec => 0)
			else
				@search_time = @search_date + (60*60*params[:listings_date_picker_time_select].to_i)
			end
			@select_time_val = params[:listings_date_picker_time_select]
		else
			@search_time = @search_date
		end


		@end = @search_date + (60 * 60 * 24)
		@end_t = @end

		@search_date_t = @search_date
		@search_date   = Listing.format_time @search_date

		# ==== End: Get Params And Make Necessary Time Variables
		get_all_channels
		if params[:changed].eql? "true"
			current_user.stations.destroy_all
			@all_channels.each do |ch|
				if params[:status][ch.callsign + '--' + ch.s_number].eql? "true"
					current_user.stations << ch
				end
			end
		end 
		
		# ==== Start: Read JSON data which contains tv listings
		#
		#   @tv_listing instance keeps tv listings data.
		@tv_listing = []

		@utc_start = Time.now.getlocal("+00:00").change(:hour => 0, :min => 0, :sec => 0)
		@utc_one_day_ago = @utc_start - 1.day

		
		if (@utc_offset < 0 && @search_date_t.strftime('%Y-%m-%d') < @utc_start.strftime('%Y-%m-%d')) || (@utc_offset > 0 && @search_date_t.strftime('%Y-%m-%d') == @utc_start.strftime('%Y-%m-%d'))
			updated_date = @utc_one_day_ago
		else
			updated_date = @utc_start
		end 


		user_favorite_channels

		sql_for_channels = ''
		if not @favorite_channels.blank?
			sql_for_channels = ' AND ('
			# sql_for_chan_numbers = ' AND ('
			@favorite_channels.each_with_index do |ch, index|
				if index == @favorite_channels.length - 1
					sql_for_channels = sql_for_channels + "(s_id=" + ch.s_id.to_s + " AND s_number='" + ch.s_number.to_s + "'))"
					# sql_for_chan_numbers = sql_for_chan_numbers + 'listings.channel_number=' + ch.channel_number.to_s + ')'
					break	
				end
				sql_for_channels = sql_for_channels + "(s_id=" + ch.s_id.to_s + " AND s_number='" + ch.s_number.to_s + "') OR "
				# sql_for_chan_numbers = sql_for_chan_numbers + 'listings.channel_number=' + ch.number.to_s + ' OR '
			end
			# sql_for_channels = sql_for_chan_numbers
			# sql_for_channels = sql_for_channels + sql_for_chan_numbers
		end

		if not sql_for_channels.eql? ''
			@tv_listing = Listing.select("*, list_date_time + interval '1 minute' * " + @utc_offset.to_s + " AS locale_time").where("updated_date = ? AND list_date_time + interval '1 minute' * listings.duration  > ? AND list_date_time < ?" + sql_for_channels, @utc_one_day_ago, @search_date_t.getlocal("+00:00"), @end_t.getlocal("+00:00")).order("s_id ASC, s_number ASC, list_date_time ASC")
		end

		# ==== End: Read JSON data which contains tv listings

	end

	def show
		
  		# Get A Keyword Param For Movie Search By A Name
  		if not params[:cur_now].blank? 
			@now = params[:cur_now]
			@start_t = Time.parse(@now).getlocal("+00:00").change(:hour => 0, :min => 0, :sec => 0).strftime('%Y-%m-%d %H:%M:%S')
		end

		if not params[:utc_locale].blank?
			@utc_offset = params[:utc_locale].to_i
		end
		
		# @start_t = @start.strftime('%Y-%m-%d %H:%M:%S')

  		@search_word = params[:listings_search_term]

  		@utc_start = Time.now.getlocal("+00:00").change(:hour => 0, :min => 0, :sec => 0)

  		utc_one_day_ago = @utc_start - (60 * 60 * 24)

		@tv_listing = Listing.select("*, list_date_time + interval '1 minute' * " + @utc_offset.to_s + " AS locale_time").where("episode_title ILIKE ? AND updated_date = ?", '%' + @search_word + '%', utc_one_day_ago.strftime('%Y-%m-%d')).order("list_date_time ASC, s_id ASC")  		

	end

	private
	def user_favorite_channels
		@favorite_channels = current_user.stations.order("s_id ASC, id ASC")
	end

	def get_all_channels
		@all_channels = Station.all.order("s_id ASC, id ASC")
	end

end






		