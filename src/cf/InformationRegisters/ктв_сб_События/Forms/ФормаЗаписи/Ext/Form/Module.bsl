﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Обработка.Параметры.УстановитьЗначениеПараметра("ТочкаВозникновения", Запись.ТочкаВозникновения);
	Обработка.Параметры.УстановитьЗначениеПараметра("Ид"				, Запись.Ид);
	
	ОбработкаКлиент.Параметры.УстановитьЗначениеПараметра("ТочкаВозникновения"	, Запись.ТочкаВозникновения);
	ОбработкаКлиент.Параметры.УстановитьЗначениеПараметра("Ид"					, Запись.Ид);
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	События.Параметры,
	                      |	События.Момент
	                      |ИЗ
	                      |	РегистрСведений.ктв_сб_События КАК События
	                      |ГДЕ
	                      |	События.ТочкаВозникновения = &ТочкаВозникновения
	                      |	И События.Ид = &Ид");
					  
	Запрос.УстановитьПараметр("ТочкаВозникновения"	, Запись.ТочкаВозникновения);
	Запрос.УстановитьПараметр("Ид"					, Запись.Ид);
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ВремПараметры = Выборка.Параметры.Получить();
		
		Если ТипЗнч(ВремПараметры) = Тип("Структура") Тогда
			
			Для Каждого ТекЭлемент Из ВремПараметры Цикл
				
				ВремЗначение = ТекЭлемент.Значение;
				
				Если ТипЗнч(ВремЗначение) = Тип("Строка")
				 ИЛИ ТипЗнч(ВремЗначение) = Тип("Число")
				 ИЛИ ТипЗнч(ВремЗначение) = Тип("Булево")
				 ИЛИ ТипЗнч(ВремЗначение) = Тип("Дата")
				 ИЛИ ТипЗнч(ВремЗначение) = Тип("Структура")
				 ИЛИ ТипЗнч(ВремЗначение) = Тип("ФиксированнаяСтруктура") Тогда
				ИначеЕсли ТипЗнч(ВремЗначение) = Тип("Соответствие")
				 ИЛИ ТипЗнч(ВремЗначение) = Тип("ФиксированноеСоответствие") Тогда
					СтрукутураЗначения = Новый Структура("ЭтоСоответствие, Значения", Истина, Новый Массив());
					Для Каждого ТекЭлементСоответствия Из ВремЗначение Цикл
						СтрукутураЗначения.Значения.Добавить(Новый Структура("Ключ, Значение", ТекЭлементСоответствия.Ключ, ТекЭлементСоответствия.Значение));
					КонецЦикла;
					ВремЗначение = СтрукутураЗначения;
				ИначеЕсли ТипЗнч(ВремЗначение) = Тип("Массив")
					  ИЛИ ТипЗнч(ВремЗначение) = Тип("ФиксированныйМассив")
					  ИЛИ ТипЗнч(ВремЗначение) = Тип("СписокЗначений")
					  ИЛИ ТипЗнч(ВремЗначение) = Тип("ТаблицаЗначений") Тогда
					ВремЗначение = СокрЛП(ВремЗначение);
				Иначе
					ПолноеИмя = "";
					МетаОбъект = Метаданные.НайтиПоТипу(ТипЗнч(ВремЗначение));
					Если НЕ МетаОбъект = Неопределено Тогда
						ПолноеИмя = МетаОбъект.ПолноеИмя();
					КонецЕсли;
					Если Лев(ПолноеИмя, 10) = "Справочник" Тогда
					ИначеЕсли Лев(ПолноеИмя, 22) = "ПланВидовХарактеристик" Тогда
					ИначеЕсли Лев(ПолноеИмя, 10) = "ПланСчетов" Тогда
					ИначеЕсли Лев(ПолноеИмя, 16) = "ПланВидовРасчета" Тогда
					ИначеЕсли Лев(ПолноеИмя, 10) = "ПланОбмена" Тогда
					ИначеЕсли Лев(ПолноеИмя, 12) = "Перечисление" Тогда
					ИначеЕсли Лев(ПолноеИмя, 8) = "Документ" Тогда
					ИначеЕсли Лев(ПолноеИмя, 13) = "БизнесПроцесс" Тогда
					ИначеЕсли Лев(ПолноеИмя, 6) = "Задача" Тогда
					Иначе
						ВремЗначение = СокрЛП(ВремЗначение);
					КонецЕсли;
				КонецЕсли;
				
				НоваяСтрокаПараметров = ПараметрыСобытия.Добавить();
				НоваяСтрокаПараметров.Параметр	= ТекЭлемент.Ключ;
				НоваяСтрокаПараметров.Значение	= ВремЗначение;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры //ПриСозданииНаСервере()

&НаКлиенте
Процедура ПараметрыСобытияЗначениеОткрытие(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ПараметрыСобытия.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.Значение) = Тип("Структура")
	 ИЛИ ТипЗнч(ТекущиеДанные.Значение) = Тип("ФиксированнаяСтруктура") Тогда
		Если ТекущиеДанные.Значение.Свойство("ЭтоСоответствие") Тогда
		 	ВремЗначение = Новый Соответствие();
			Для Каждого ТекЭлемент Из ТекущиеДанные.Значение.Значения Цикл
				ВремЗначение.Вставить(ТекЭлемент.Ключ, ТекЭлемент.Значение);
			КонецЦикла;
		Иначе
			ВремЗначение = ТекущиеДанные.Значение;
		КонецЕсли;
			
		СтандартнаяОбработка = Ложь;
		ФормаПросмотра = ПолучитьФорму("РегистрСведений.ктв_сб_События.Форма.ФормаПросмотраСоответствия", Новый Структура("Соответствие", ВремЗначение), ЭтаФорма.УникальныйИдентификатор, Запись.Ид + "_" + ТекущиеДанные.Параметр);
		ФормаПросмотра.Открыть();
	КонецЕсли;
	
КонецПроцедуры
