# Time to report
Генератор дедлайна до ближайшего отчёта
Этот скрипт написан  на языке Ruby и предназначен длягенерации даты ближайших дедлайнов для отчётов на основе календарных данных.

### **Как использовать**

Убедитесь, что у вас установлен Ruby. (ruby -v ля проверки версии, если не установлен,вначале нужно будет установить)

Склонируйте репозиторий на свой компьютер (git clone и два варианта клонирования по ssh или http).
Установите необходимые зависимости, запустив bundle install.
### **Запустите скрипт ruby main.rb.**

Получите информацию о ближайших дедлайнах и типах отчетов.

### **Описание**

Этот скрипт анализирует рабочие дни в указанном периоде, используя календарные данные  анного и следующего месяца с сайта production-calendar.ru
Он определяет ближайшие дедлайны для месячных, квартальных и годовых отчетов на основе текущей даты.

#### Класс ReportGenerator
Этот класс отвечает за  определение ближайших дедлайнов. Он имеет следующие методы:
* **monthly_report:** Определяет ближайший дедлайн для месячного отчета.
* **year_report:** Определяет ближайший дедлайн для годового отчета, если он в бближайшие два месяца
* **quarterly_report:** Определяет ближайший дедлайн для квартального отчета, если он в бближайшие два месяца
* **quarterly_report_in_month:** Определяет ближайший дедлайн для квартального отчета на 30 календарных дней,если он в бближайшие два месяца
* **years_report_in_month:** Определяет ближайший дедлайн для годового отчета на 30 календарных дней,если он в бближайшие два месяца

#### Функция _nearest_deadline_
Эта функция создает экземпляр класса _ReportGenerator_ и определяет ближайшие дедлайны для различных типов отчетов.
Она выводит информацию о ближайших дедлайнах в консоль.

### **Зависимости**
Этот скрипт использует стандартные библиотеки Ruby, такие как net/http, date и json, а также библиотеку bundle для управления зависимостями.

