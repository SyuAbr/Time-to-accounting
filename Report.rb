require 'net/http'
require 'date'
require 'json'

class ReportGenerator
  attr_reader :day, :work_days_array, :ten_work_day_in_month, :ten_work_day_next_month
  def initialize
    @day = Date.today
    @work_days_array = fetch_work_days
    @ten_work_day_in_month = @work_days_array[9]
    @ten_work_day_next_month = @work_days_array.select { |date| date.month == (@day >> 1).month}[9]
  end

  def fetch_work_days
    start_date = Date.new(@day.year, @day.month, 1)
    end_date = start_date >> 2
    uri = URI.parse("https://production-calendar.ru/get-period/383a4629688207336d534f68d6a676c1/Ru/#{start_date.strftime('%d.%m.%Y')}-#{end_date.strftime('%d.%m.%Y')}/json")
    response = Net::HTTP.get(uri)
    dates = JSON.parse(response)['days']
    dates.map {|date| Date.parse(date['date']) if date['type_text'].downcase.include?('рабочий день') }.compact
  end

  def monthly_report
    if @day <= @ten_work_day_in_month
      ten_work_day_in_month
    else
      @ten_work_day_next_month
    end
  end

  def year_report
    unless (@day.month == 12) || (day.month == 1 && day <= @ten_work_day_in_month)
      return nil
    end
    if @day.month == 12
      @ten_work_day_next_month
    else
      @ten_work_day_in_month
    end
  end

  def quarterly_report
    unless ([3, 6, 9].include?(@day.month)) || ([4, 7, 10].include?(@day.month) && @day <= @ten_work_day_in_month)
      return nil
    end
    if [3, 6, 9].include?(@day.month)
      @ten_work_day_next_month
    else
      @ten_work_day_in_month
    end
  end

  def quarterly_report_in_month
    date_report = Date.new(@day.year, @day.month, 1)
    date_report += 29
    unless ([3, 6, 9].include?(@day.month)) || ([4, 7, 10].include?(@day.month) && @day <= date_report)
      return nil
    end
    if [3, 6, 9].include?(@day.month)
      date_report.next_month
    else
      date_report
    end
  end

  def years_report_in_month
    date_report=Date.new(@day.year, 1, 30)
    unless ([12].include?(@day.month)) || ([1].include?(@day.month) and @day < date_report)
      return nil
    end
    if [12].include?(@day.month)
      Date.new(@day.next_year.year, 1, 30)
    else
      date_report
    end
  end
end
def nearest_deadline
  report_generator = ReportGenerator.new
  deadlines = {}

  report = report_generator.monthly_report
  deadlines[report.to_s] ||= []
  deadlines[report.to_s] << 'Месячный отчёт'

  report = report_generator.year_report
  unless report.nil?
    deadlines[report.to_s] ||= []
    deadlines[report.to_s] << 'Годовой отчёт'
  end

  report = report_generator.years_report_in_month
  unless  report.nil?
    deadlines[report.to_s] ||= []
    deadlines[report.to_s] << 'Годовой отчёт на 30 календарных дней'
  end
  report = report_generator.quarterly_report
  unless report.nil?
    deadlines[report.to_s] ||= []
    deadlines[report.to_s] << 'Квартальный отчёт'
  end

  report = report_generator.quarterly_report_in_month
  unless report.nil?
    deadlines[report.to_s] ||= []
    deadlines[report.to_s] << 'Квартальный отчёт на 30 календарных дней'
  end

  min_deadline = deadlines.keys.min
  min_deadline_types = deadlines[min_deadline]

  min_deadline_types.each do |type|
    puts " Ближайший дедлайн: #{min_deadline}\n Тип отчета: #{type}\n Осталось дней: #{(Date.parse(min_deadline)- report_generator.day).to_i } "
    puts '-----------------------------------------------------------------------------------------'
  end
end
nearest_deadline
