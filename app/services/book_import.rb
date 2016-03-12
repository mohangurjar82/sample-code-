require 'thread/pool'
class BookImport
  def initialize(file_path)
    @doc = File.open(file_path) { |f| Nokogiri::XML(f) }
    # pre-load classes (it fails in threads)
    MPX::ResourceService
    MPX::FileManagement
    MPX::RemoteResource
    MPX::Media
  end

  def process
    books = Concurrent::Array.new(@doc.xpath('//Product'))
    books_count = books.count
    pool = Thread.pool(5)
    books_count.times do |n|
      pool.process do
        puts "process book #{n}"
        begin
          import_book(books[n])
        rescue Exception => e
          puts "Exception with book #{n}!"
          puts e.class.to_s + ' ' + e.message
        end
        
      end
    end
    pool.wait(:done)

    puts "#{books.size} books imported"
  end

  def import_book(book)
    attributes = parse_book_attributes(book)
    media = MPX::Media.new
    attributes.each do |field, value|
      media.send("#{field}=", value)
    end
    media.category = 'E-Books'
    media.save
    MPX::FileManagement.link_file(media.id, cover_file(book))
    MPX::FileManagement.link_file(media.id, pdf_file(book))
  end

  def parse_book_attributes(book)
    {
      author: [css(book, 'NamesBeforeKey'), css(book, 'KeyNames')].join(' '),
      title: css(book, 'TitleText'),
      description: css(book, 'Text'),
      eAN: css(book, 'EAN'),
      iSBN: css(book, 'ISBN'),
      numberOfPages: css(book, 'NumberOfPages'),
      publicationDate: format_date(css(book, 'PublicationDate')),
      publisherName: css(book, 'PublisherName'),
      recordReference: css(book, 'RecordReference')
    }
  end

  def css(book, css_path)
    value = book.css(css_path).text rescue nil
  end

  def format_date(date_str)
    Date.parse(date_str).strftime('%Y-%m-%d') rescue nil
  end

  def cover_file(book)
    name = File.basename book.css('CoverImageLink').text
    if name.present?
      'http://www.n2me.tv/demo/images/ebooks/' << name
    else
      nil
    end
  end

  def pdf_file(book)
    name = File.basename book.css('TextLink').text
    if name.present?
      'http://www.n2me.tv/demo/images/ebooks/' << name
    else
      nil
    end
  end
end