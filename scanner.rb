require 'httparty'
require 'optparse'
require 'uri'
require 'logger'

# إعداد سجل لتسجيل الأحداث
logger = Logger.new('scanner.log')

# دالة لفحص حقن SQL
def check_sql_injection(url, logger)
  puts "\n[*] Checking #{url} for SQL Injection vulnerabilities..."
  logger.info("[*] Checking #{url} for SQL Injection vulnerabilities...")
  payloads = ["'", "';", "--", "' OR '1'='1", "\" OR \"1\"=\"1\""]

  payloads.each do |payload|
    full_url = "#{url}#{payload}"
    begin
      response = HTTParty.get(full_url)

      if response.body.include?("SQL") || response.body.include?("syntax")
        puts "[!] Possible SQL Injection vulnerability found with payload: #{payload}"
        logger.warn("[!] Possible SQL Injection vulnerability found with payload: #{payload}")
      else
        puts "[ ] No vulnerability found with payload: #{payload}"
        logger.info("[ ] No vulnerability found with payload: #{payload}")
      end
    rescue => e
      puts "[!] Error accessing #{full_url}: #{e.message}"
      logger.error("[!] Error accessing #{full_url}: #{e.message}")
    end
    sleep(1)  # تأخير لمدة ثانية لتجنب الحظر
  end
end

# دالة لفحص XSS
def check_xss(url, logger)
  puts "\n[*] Checking #{url} for XSS vulnerabilities..."
  logger.info("[*] Checking #{url} for XSS vulnerabilities...")
  payloads = ['<script>alert(1)</script>', '"><script>alert(1)</script>', "<img src=x onerror=alert(1)>"]

  payloads.each do |payload|
    full_url = "#{url}?input=#{URI::DEFAULT_PARSER.escape(payload)}"
    begin
      response = HTTParty.get(full_url)

      if response.body.include?("alert(1)")
        puts "[!] Possible XSS vulnerability found with payload: #{payload}"
        logger.warn("[!] Possible XSS vulnerability found with payload: #{payload}")
      else
        puts "[ ] No vulnerability found with payload: #{payload}"
        logger.info("[ ] No vulnerability found with payload: #{payload}")
      end
    rescue => e
      puts "[!] Error accessing #{full_url}: #{e.message}"
      logger.error("[!] Error accessing #{full_url}: #{e.message}")
    end
    sleep(1)  # تأخير لمدة ثانية لتجنب الحظر
  end
end

# دالة رئيسية لمعالجة المدخلات من سطر الأوامر
def main(logger)
  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: ruby scanner.rb [options]"

    opts.on("-u", "--url URL", "URL to scan") do |url|
      options[:url] = url
    end

    opts.on("-t", "--type TYPE", "Type of scan (sql, xss, both)") do |type|
      options[:type] = type.downcase
    end
  end.parse!

  if options[:url].nil?
    puts "Please provide a URL using -u option."
    exit
  end

  url = options[:url]

  # التأكد من أن URL هو عنوان صالح
  begin
    uri = URI.parse(url)
    raise URI::InvalidURIError unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  rescue URI::InvalidURIError
    puts "Invalid URL format. Please provide a valid URL."
    exit
  end

  # تنفيذ الفحوصات بناءً على النوع المحدد
  if options[:type] == "sql"
    check_sql_injection(url, logger)
  elsif options[:type] == "xss"
    check_xss(url, logger)
  else
    check_sql_injection(url, logger)
    check_xss(url, logger)
  end
end

# بدء تنفيذ البرنامج وتمرير متغير logger إلى الدالة الرئيسية
main(logger)
