require 'httparty'
require 'json'
require 'pp'

class SchedulesController < ApplicationController
	before_filter :authenticate_user!
	layout 'new_layout'

	before_action :get_lineups
	before_action :make_json_file

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
		@start = format_time @start

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
		@search_date   = format_time @search_date

		# ==== End: Get Params And Make Necessary Time Variables

		
		# ==== Start: Read JSON data which contains tv listings
		#
		#   @tv_listing instance keeps tv listings data.
		@utc_start = Time.now.getlocal("+00:00").change(:hour => 0, :min => 0, :sec => 0)
		@utc_one_day_ago = @utc_start - 1.day

		if (@utc_offset < 0 && @search_date_t.strftime('%Y-%m-%d') < @utc_start.strftime('%Y-%m-%d')) || (@utc_offset > 0 && @search_date_t.strftime('%Y-%m-%d') == @utc_start.strftime('%Y-%m-%d'))
			path = File.join(Rails.root, "config", "sample-" + @utc_one_day_ago.strftime('%Y-%m-%d') + ".json")
		else
			path = File.join(Rails.root, "config", "sample-" + @utc_start.strftime('%Y-%m-%d') + ".json")
		end 

		json = File.read(path)		
		@tv_listing = []
		tmp_listing = JSON.parse(json)

		tmp_listing.each do |item|
			locale_time = Time.parse(item['listDateTime']) + (@utc_offset * 60)
			with_duration = locale_time + (item['duration'] * 60)
			if with_duration > @search_date_t && locale_time < @end_t
				item['listDateTime'] = locale_time.strftime('%Y-%m-%d %H:%M:%S')
				@tv_listing.push(item)
			else
				next
			end
		end
		# ==== End: Read JSON data which contains tv listings

	end

	def show
		
  		# Get A Keyword Param For Movie Search By A Name
  		if not params[:cur_now].blank? 
			@now = params[:cur_now]
			@start = Time.parse(@now).change(:hour => 0, :min => 0, :sec => 0)
		end
		
		@start_t = @start

  		@search_word = params[:listings_search_term]

  		@utc_start = Time.now.getlocal("+00:00").change(:hour => 0, :min => 0, :sec => 0)
		path = File.join(Rails.root, "config", "sample-" + @utc_start.strftime('%Y-%m-%d') + ".json")
		
		json = File.read(path)		
		@tv_listing = []
		tmp_listing = JSON.parse(json)

		upcase_word = @search_word.upcase
		
		tmp_listing.each do |item|
			if item['episodeTitle'].upcase.include? upcase_word
				@tv_listing.push(item)
			else
				next
			end
		end
	end

	private

	# ==== return a lineup URI
  	def get_lineups
  		@lineups = 'http://api.tvmedia.ca/tv/v4/lineups/36211D/listings?'
  	end

  	# ==== replace a blank space with %20 for HTTP request URI
  	def replace_space str
  		str = str.gsub(/[ ]/, '%20')
  	end

  	# ==== replace a colon with %3A for HTTP request URI
  	def replace_colon str
  		str = str.gsub(/[:]/, '%3A')
  	end

  	# ==== replace a comma with %2C for HTTP request URI
  	def replace_comma str
  		str = str.gsub(/[,]/, '%2C')
  	end

  	# ==== return channels in a HTTP URI formation
  	def get_channels
  		'227%2C399%2C101%2C167%2C168%2C180%2C313%2C328%2C398%2C439%2C470%2C490%2C499%2C562%2C563%2C564%2C565%2C566%2C567'
  	end

  	# ==== format time for HTTP request URI
  	def format_time time
  		time = time.strftime('%Y-%m-%d %H:%M')
  		time = replace_space time
  		replace_colon time
  	end


  	# Make JSON files which contain tv listing of Today and Yesterday
  	# And delete 2 days ago JSON data
  	def make_json_file
		# @search_date = @search_time_t.change(:hour => 0, :min => 0, :sec => 0)
		utc_start = Time.now.getlocal("+00:00").change(:hour => 0, :min => 0, :sec => 0)
		utc_one_day_ago = utc_start - 1.day
		utc_two_days_ago = utc_start - 2.days

		path = File.join(Rails.root, "config", "sample-" + utc_start.strftime('%Y-%m-%d') + ".json")
		if not File.exists?(path)
			channel = get_channels
			utc_end = utc_start + (60 * 60 * 24 * 14)
			utc_start = format_time utc_start
			utc_end   = format_time utc_end
			request_str = @lineups + 'api_key=' + ENV['TV_MEDIA_API_KEY'] + '&start=' + utc_start + '&end=' + utc_end + '&channel=' + channel + '&pretty=1'
			response = HTTParty.get(request_str)
			File.open(path, "w+") do |f|
				f.write(response.body)
			end	
		end 

		path = File.join(Rails.root, "config", "sample-" + utc_one_day_ago.strftime('%Y-%m-%d') + ".json")
		if not File.exists?(path)
			utc_end = utc_one_day_ago + (60 * 60 * 24 * 14)
			utc_one_day_ago = format_time utc_one_day_ago
			utc_end   = format_time utc_end
			request_str = @lineups + 'api_key=' + ENV['TV_MEDIA_API_KEY'] + '&start=' + utc_one_day_ago + '&end=' + utc_end + '&channel=' + channel + '&pretty=1'
			response = HTTParty.get(request_str)
			File.open(path, "w+") do |f|
				f.write(response.body)
			end	
		end

		path = File.join(Rails.root, "config", "sample-" + utc_two_days_ago.strftime('%Y-%m-%d') + ".json")
		if File.exists?(path)
			File.delete(path)
		end

  	end
end






		