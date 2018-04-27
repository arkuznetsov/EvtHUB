﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОбработкаНастройкиАдресВХранилище") Тогда
		ОбработкаНастройкиАдресВХранилище = Параметры.ОбработкаНастройкиАдресВХранилище;
	
		Настройки = ПолучитьИзВременногоХранилища(ОбработкаНастройкиАдресВХранилище);
	
		Если ТипЗнч(Настройки) = Тип("Структура") Тогда
			Попытка
				ЗаполнитьТочкиПроверкиСобытий(Настройки);
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры //ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТочкиПроверкиСобытийПриАктивизацииСтроки(Элемент)
	
	Если НЕ ТочкаПроверкиСобытия_Текущая = Неопределено Тогда
		ТекущиеДанные = ТочкиПроверкиСобытий.НайтиПоИдентификатору(ТочкаПроверкиСобытия_Текущая);
		ТекущиеДанные.Значение.Код = ТочкаПроверкиСобытия_Код;
	КонецЕсли;
		
	ТочкаПроверкиСобытия_Текущая = Элементы.ТочкиПроверкиСобытий.ТекущаяСтрока;
	
	Если ТочкаПроверкиСобытия_Текущая = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ТочкиПроверкиСобытий.НайтиПоИдентификатору(ТочкаПроверкиСобытия_Текущая);
	
	Элементы.ТочкаПроверкиСобытия_ИмяФункции.Заголовок = СокрЛП(ТекущиеДанные.Значение.МоментПроверки)
													   + "(Источник, Событие, ПараметрыПодписки, ПараметрыСобытия)";
	
	ТочкаПроверкиСобытия_Код = ТекущиеДанные.Значение.Код;
	
КонецПроцедуры //ТочкиПроверкиСобытийПриАктивизацииСтроки()

&НаКлиенте
Процедура ТочкаПроверкиСобытия_КодПриИзменении(Элемент)
	
	Если НЕ ТочкаПроверкиСобытия_Текущая = Неопределено Тогда
		ТекущиеДанные = ТочкиПроверкиСобытий.НайтиПоИдентификатору(ТочкаПроверкиСобытия_Текущая);
		ТекущиеДанные.Значение.Код = ТочкаПроверкиСобытия_Код;
	КонецЕсли;
	
КонецПроцедуры //ТочкаПроверкиСобытия_КодПриИзменении()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьНастройку(Команда)
	
	СохранитьНастройкуНаСервере();
	
	Оповестить("ИзмененыНастройки", ЭтаФорма.ВладелецФормы, ЭтаФорма);
	
	Закрыть("ИзмененыНастройки");
	
КонецПроцедуры //СохранитьНастройку()

&НаСервере
Процедура СохранитьНастройкуНаСервере()
	
	Настройка = Новый Структура();
	
	Для Каждого ТекЭлемент Из ТочкиПроверкиСобытий Цикл
		
		Если НЕ ТекЭлемент.Пометка Тогда
			Продолжить;
		КонецЕсли; 
		
	    Настройка.Вставить(ТекЭлемент.Значение.ИмяНастройки, ТекЭлемент.Значение.Код);
	КонецЦикла; 
	
	//Настройка.Вставить("ОбработкаПередЗаписью_Код",	ОбработкаПередЗаписью_Код);
	//Настройка.Вставить("ОбработкаПриЗаписи_Код",		ОбработкаПриЗаписи_Код);
	//Настройка.Вставить("ОбработкаПередУдалением_Код",	ОбработкаПередУдалением_Код);
	//Настройка.Вставить("ОбработкаВнеСобытия_Код",		ОбработкаВнеСобытия_Код);
	
	ПоместитьВоВременноеХранилище(Настройка, ОбработкаНастройкиАдресВХранилище);
	
КонецПроцедуры //СохранитьНастройкуНаСервере()

#КонецОбласти

#Область СлужебныеПроцедуры

// Процедура - Заполняет список точек проверки событий
// и устанавливает для них код проверки возникновения событий из сохраненных настроек
//
// Параметры:
//  Настройки	 - Структура	 - Сохраненные настройки
//
&НаСервере
Процедура ЗаполнитьТочкиПроверкиСобытий(Настройки)

	//ВсеОбъекты.ПриКопировании
	ТочкиПроверкиСобытий.Добавить(Новый Структура("МоментПроверки,
												  |ИмяНастройки,
												  |Код",
												  "ПриКопировании",
												  "ОбработкаПриКопировании_Код",
												  "")
								, "ПриКопировании"
								, Ложь);
	//ВсеОбъекты.ПередЗаписью
	//ВсеНаборыЗаписей.ПередЗаписью
	ТочкиПроверкиСобытий.Добавить(Новый Структура("МоментПроверки,
												  |ИмяНастройки,
												  |Код",
												  "ПередЗаписью",
												  "ОбработкаПередЗаписью_Код",
												  "")
								, "ПередЗаписью"
								, Ложь);
	//ВсеОбъекты.ПриЗаписи
	//ВсеНаборыЗаписей.ПриЗаписи
	ТочкиПроверкиСобытий.Добавить(Новый Структура("МоментПроверки,
												  |ИмяНастройки,
												  |Код",
												  "ПриЗаписи",
												  "ОбработкаПриЗаписи_Код",
												  "")
								, "ПриЗаписи"
								, Ложь);
	//ВсеОбъекты.ПередУдалением
	ТочкиПроверкиСобытий.Добавить(Новый Структура("МоментПроверки,
												  |ИмяНастройки,
												  |Код",
												  "ПередУдалением",
												  "ОбработкаПередУдалением_Код",
												  "")
								, "ПередУдалением"
								, Ложь);
	//ВсеОбъекты.ОбработкаЗаполнения
	//РегистрСведенийНаборЗаписей.ОбработкаЗаполнения
	ТочкиПроверкиСобытий.Добавить(Новый Структура("МоментПроверки,
												  |ИмяНастройки,
												  |Код",
												  "ОбработкаЗаполнения",
												  "ОбработкаОбработкаЗаполнения_Код",
												  "")
								, "ОбработкаЗаполнения"
								, Ложь);
	//ВсеОбъекты.ОбработкаПроверкиЗаполнения
	//ВсеНаборыЗаписей.ОбработкаПроверкиЗаполнения
	ТочкиПроверкиСобытий.Добавить(Новый Структура("МоментПроверки,
												  |ИмяНастройки,
												  |Код",
												  "ОбработкаПроверкиЗаполнения",
												  "ОбработкаОбработкаПроверкиЗаполнения_Код",
												  "")
								, "ОбработкаПроверкиЗаполнения"
								, Ложь);

	//Документы.ОбработкаПроведения
	ТочкиПроверкиСобытий.Добавить(Новый Структура("МоментПроверки,
												  |ИмяНастройки,
												  |Код",
												  "ОбработкаПроведения",
												  "ОбработкаОбработкаПроведения_Код",
												  "")
								, "ОбработкаПроведения"
								, Ложь);
	//Документы.ОбработкаУдаленияПроведения
	ТочкиПроверкиСобытий.Добавить(Новый Структура("МоментПроверки,
												  |ИмяНастройки,
												  |Код",
												  "ОбработкаУдаленияПроведения",
												  "ОбработкаОбработкаУдаленияПроведения_Код",
												  "")
								, "ОбработкаУдаленияПроведения"
								, Ложь);
	//БизнесПроцессыЗадачи.ОбработкаИнтерактивнойАктивации
	ТочкиПроверкиСобытий.Добавить(Новый Структура("МоментПроверки,
												  |ИмяНастройки,
												  |Код",
												  "ОбработкаИнтерактивнойАктивации",
												  "ОбработкаОбработкаИнтерактивнойАктивации_Код",
												  "")
								, "ОбработкаИнтерактивнойАктивации"
								, Ложь);
	//Задачи.ОбработкаПроверкиВыполнения
	ТочкиПроверкиСобытий.Добавить(Новый Структура("МоментПроверки,
												  |ИмяНастройки,
												  |Код",
												  "ОбработкаПроверкиВыполнения",
												  "ОбработкаОбработкаПроверкиВыполнения_Код",
												  "")
								, "ОбработкаПроверкиВыполнения"
								, Ложь);
	//Задачи.ПередВыполнением
	ТочкиПроверкиСобытий.Добавить(Новый Структура("МоментПроверки,
												  |ИмяНастройки,
												  |Код",
												  "ПередВыполнением",
												  "ОбработкаПередВыполнением_Код",
												  "")
								, "ПередВыполнением"
								, Ложь);
	//Задачи.ПередИнтерактивнымВыполнением
	ТочкиПроверкиСобытий.Добавить(Новый Структура("МоментПроверки,
												  |ИмяНастройки,
												  |Код",
												  "ПередИнтерактивнымВыполнением",
												  "ОбработкаПередИнтерактивнымВыполнением_Код",
												  "")
								, "ПередИнтерактивнымВыполнением"
								, Ложь);
	//Задачи.ПриВыполнении
	ТочкиПроверкиСобытий.Добавить(Новый Структура("МоментПроверки,
												  |ИмяНастройки,
												  |Код",
												  "ПриВыполнении",
												  "ОбработкаПриВыполнении_Код",
												  "")
								, "ПриВыполнении"
								, Ложь);
	
	Если НЕ ТипЗнч(Настройки) = Тип("Структура") Тогда
		Возврат;								
	КонецЕсли;
	
	Для Каждого ТекЭлемент Из ТочкиПроверкиСобытий Цикл
		
		Если НЕ Настройки.Свойство(ТекЭлемент.Значение.ИмяНастройки) Тогда
			Продолжить;
		КонецЕсли; 
		
		ТекЭлемент.Значение.Код = Настройки[ТекЭлемент.Значение.ИмяНастройки];
		ТекЭлемент.Пометка = НЕ ПустаяСтрока(ТекЭлемент.Значение.Код);
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьТочкиПроверкиСобытий()
 
#КонецОбласти
