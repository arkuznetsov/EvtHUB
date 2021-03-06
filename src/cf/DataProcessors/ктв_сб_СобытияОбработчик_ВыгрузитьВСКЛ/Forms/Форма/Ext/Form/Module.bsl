﻿&НаКлиенте
Перем ФормаРедактированияЗапроса Экспорт; //Хранит ссылку на форму редактора запросов

#Область ОбработчикиСобытийФормы

// Процедура - обработчик события "ПриСозданииНаСервере
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОбработкаНастройкиАдресВХранилище") Тогда
		ОбработкаНастройкиАдресВХранилище = Параметры.ОбработкаНастройкиАдресВХранилище;
	
		Настройки = ПолучитьИзВременногоХранилища(ОбработкаНастройкиАдресВХранилище);
	
		Если ТипЗнч(Настройки) = Тип("Структура") Тогда
			Настройки.Свойство("НастройкаСоединения"			, НастройкаСоединения);
			Настройки.Свойство("ИмяТаблицыСУБД"					, ИмяТаблицыСУБД);
			Настройки.Свойство("УзелКонтроляИзменений"			, УзелКонтроляИзменений);
			Настройки.Свойство("КоличествоСтрокВВыборкеДанных"	, КоличествоСтрокВВыборкеДанных);
			Настройки.Свойство("КоличествоСтрокВТранзакцииСУБД"	, КоличествоСтрокВТранзакцииСУБД);
			Настройки.Свойство("ОбработкаПустогоРезультатаЗапроса"	, ОбработкаПустогоРезультатаЗапроса);
			
			Попытка
				ЗаполнитьТаблицуИзМассиваСтруктур("ЗаполнениеПолей", Настройки.ЗаполнениеПолей);
			Исключение
			КонецПопытки;
			
		КонецЕсли;
	КонецЕсли;
	
	ПодготовитьШаблоныНастроек();
	
	ОбновитьСписокТаблицНаСервере();
	
	ОбновитьСписокПолейСУБДНаСервере();
	
КонецПроцедуры //ПриСозданииНаСервере()

// Процедура - обработчик события "ПриОткрытии
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ФормаРедактированияЗапроса();
	
	ОбновитьСписокКолонокЗапроса();
	
КонецПроцедуры //ПриОткрытии()

// Процедура - Обработка оповещения
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыНастройки" И Параметр = ЭтаФорма Тогда
		ОбновитьСписокКолонокЗапроса();
	ИначеЕсли ИмяСобытия = "ИзмененыПоляКлюча" И ТипЗнч(Параметр) = Тип("Структура") Тогда
		Если НЕ ТипЗнч(Параметр) = Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		
		Если НЕ Параметр.Свойство("Приемник") Тогда
			Возврат;
		КонецЕсли;
		
		Если НЕ Параметр.Приемник = ЭтаФорма Тогда
			Возврат;
		КонецЕсли;
		
		ТекущиеДанные = Неопределено;
		Попытка
			ТекущиеДанные = ЗаполнениеПолей[Параметр.ТекущаяСтрока];
		Исключение
		КонецПопытки;
		
		Если НЕ ТекущиеДанные = Неопределено Тогда
			ТекущиеДанные.ПоляКлюча					= Параметр.ПоляКлюча;
			ТекущиеДанные.ПоляКлючаПредставление	= Параметр.ПоляКлючаПредставление;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры //ОбработкаОповещения()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

// Процедура - Обработчик события "ПриИзменении" поля "НастройкаСоединения" формы
//
&НаКлиенте
Процедура НастройкаСоединенияПриИзменении(Элемент)
	
	ОбновитьСписокТаблицНаСервере();
	
КонецПроцедуры //НастройкаСоединенияПриИзменении()

// Процедура - Обработчик события "ПриИзменении" поля "ИмяТаблицыСУБД" формы
//
&НаКлиенте
Процедура ИмяТаблицыСУБДПриИзменении(Элемент)
	
	ОбновитьСписокПолейСУБДНаСервере();
	
КонецПроцедуры //ИмяТаблицыСУБДПриИзменении()

// Процедура - Обработчик события "ПриИзменении" поля "ЗаполнениеПолейТаблицаИсточник" таблицы "ЗаполнениеПолей" формы
//
&НаКлиенте
Процедура ЗаполнениеПолейТаблицаИсточникПриИзменении(Элемент)
	
	Элементы.ЗаполнениеПолейПолеЗначения.СписокВыбора.Очистить();
	
	ТекущиеДанные = Элементы.ЗаполнениеПолей.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивПолей = ПолучитьСписокПолейТаблицыСУБДНаСервере(ТекущиеДанные.ТаблицаИсточник);
	
	Для Каждого ТекПоле Из МассивПолей Цикл
			
		Элементы.ЗаполнениеПолейПолеЗначения.СписокВыбора.Добавить(ТекПоле);
	
	КонецЦикла;
	
КонецПроцедуры //ЗаполнениеПолейТаблицаИсточникПриИзменении()

// Процедура - Обработчик события "ПриНачалеРедактирования" таблицы "ЗаполнениеПолей" формы
//
&НаКлиенте
Процедура ЗаполнениеПолейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ЗаполнениеПолейТаблицаИсточникПриИзменении(Элемент);
	
КонецПроцедуры //ЗаполнениеПолейПриНачалеРедактирования()

// Процедура - Обработчик события "НачалоВыбора" поля "ПоляКлюча" таблицы "ЗаполнениеПолей" формы
//
&НаКлиенте
Процедура ЗаполнениеПолейПоляКлючаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекСтрока = ЗаполнениеПолей.Индекс(Элементы.ЗаполнениеПолей.ТекущиеДанные);
	
	Если ТекСтрока = Неопределено Тогда
		ПоляКлюча = "";
		ТаблицыСУБД = Новый Массив();
		КолонкиСУБД = Новый Массив();
		КолонкиЗапроса = Новый Массив();
	Иначе
		ТаблицыСУБД = Элементы.ИмяТаблицыСУБД.СписокВыбора.ВыгрузитьЗначения();
		
		КолонкиСУБД = ПолучитьСписокПолейТаблицыСУБДНаСервере(ЗаполнениеПолей[ТекСтрока].ТаблицаИсточник);
		
		ОписаниеКолонок = ФормаРедактированияЗапроса().ПолучитьКолонкиЗапроса();
		
		КолонкиЗапроса = Новый Массив();
		
		Для Каждого ТекКолонка Из ОписаниеКолонок Цикл
			КолонкиЗапроса.Добавить(ТекКолонка.Имя);
		КонецЦикла;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ТаблицыСУБД, КолонкиСУБД, КолонкиЗапроса, ПоляКлюча, ТекущаяСтрока"
								   , ТаблицыСУБД
								   , КолонкиСУБД
								   , КолонкиЗапроса
								   , ЗаполнениеПолей[ТекСтрока].ПоляКлюча
								   , ТекСтрока);
	
	ФормаСпискаПолейКлюча = ПолучитьФорму("Обработка.ктв_сб_СобытияОбработчик_ВыгрузитьВСКЛ.Форма.ФормаКлючевыеПоля", ПараметрыФормы, ЭтаФорма);
	ФормаСпискаПолейКлюча.ФормаНастройкиЗаполненияПолей = ЭтаФорма;
	ФормаСпискаПолейКлюча.Открыть();
	
КонецПроцедуры //ЗаполнениеПолейПоляКлючаНачалоВыбора()

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - Обработчик команды "СохранитьНастройку"
//
&НаКлиенте
Процедура СохранитьНастройку(Команда)
	
	Настройка = ПодготовитьНастройкиДляСохранения(ФормаРедактированияЗапроса().ПолучитьЗапросСПараметрами(), Ложь);
	
	ПоместитьВоВременноеХранилище(Настройка, ОбработкаНастройкиАдресВХранилище);
	
	Оповестить("ИзмененыНастройки", ЭтаФорма.ВладелецФормы, ЭтаФорма);
	
КонецПроцедуры //СохранитьНастройку()

// Процедура - Обработчик команды "СохранитьНастройкуИЗакрыть"
//
&НаКлиенте
Процедура СохранитьНастройкуИЗакрыть(Команда)
	
	СохранитьНастройку(Команда);
	
	Закрыть("ИзмененыНастройки");
	
КонецПроцедуры //СохранитьНастройкуИЗакрыть()

// Процедура - Обработчик команды "РедактироватьЗапрос" - открывает редактор запроса
//
&НаКлиенте
Процедура РедактироватьЗапрос(Команда)
	
	ФормаРедактированияЗапроса.Открыть();
	
КонецПроцедуры //РедактироватьЗапрос()

// Процедура - Обработчик команды "ПоказатьТекстЗапросаСКЛ" - открывает редактор запроса
//
&НаКлиенте
Процедура ПоказатьТекстЗапросаСКЛ(Команда)
	
	НастройкиПолученияДанных = ФормаРедактированияЗапроса().ПолучитьЗапросСПараметрами();
	
	ВремТекст = Новый ТекстовыйДокумент();
	ВремТекст.УстановитьТекст(ПолучитьТекстЗапросаСКЛНаСервере(НастройкиПолученияДанных));
	ВремТекст.Показать("Текст запроса SQL");
	
КонецПроцедуры //ПоказатьТекстЗапросаСКЛ()

// Процедура - Обработчик команды "СохранитьНастройкиВФайл"
//
&НаКлиенте
Процедура СохранитьНастройкиВФайл(Команда)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Фильтр				= "Текстовые файлы (*.txt)|*.txt|Все файлы (*.*)|*.*";
	Диалог.Расширение			= "txt";
	Диалог.МножественныйВыбор	= Ложь;
	
	ОповещениеВыбораФайла = Новый ОписаниеОповещения("СохранитьНастройкиВФайлОбработка", ЭтаФорма);
	
	Диалог.Показать(ОповещениеВыбораФайла);
	
КонецПроцедуры //СохранитьНастройкиВФайл()

// Процедура - Продолжение обработчика команды "СохранитьНастройкиВФайл"
//				после выполнения выбора файла для сохранения
//
// Параметры:
//  ВыбранныеФайлы		 - Массив		 - Имена выбранных файлов
//  Параметры			 - Структура	 - Параметры переданные из команды "СохранитьНастройкиВФайл"
//
&НаКлиенте
Процедура СохранитьНастройкиВФайлОбработка(ВыбранныеФайлы, Параметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Настройки = ПодготовитьНастройкиДляСохранения(ФормаРедактированияЗапроса().ПолучитьЗапросСПараметрами(), Истина);
	
	ВремТекст = Новый ТекстовыйДокумент();
	ВремТекст.УстановитьТекст(ПолучитьТекстНастроекДляСохранения(Настройки));
	
	ВремТекст.Записать(ВыбранныеФайлы[0]);
	
КонецПроцедуры //СохранитьНастройкиВФайлОбработка()

// Процедура - Обработчик команды "ЗагрузитьНастройкиИзФайла"
//
&НаКлиенте
Процедура ЗагрузитьНастройкиИзФайла(Команда)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Фильтр				= "Текстовые файлы (*.txt)|*.txt|Все файлы (*.*)|*.*";
	Диалог.Расширение			= "txt";
	Диалог.МножественныйВыбор	= Ложь;
	
	ОповещениеВыбораФайла = Новый ОписаниеОповещения("ЗагрузитьНастройкиИзФайлаОбработка", ЭтаФорма);
	
	Диалог.Показать(ОповещениеВыбораФайла);
	
КонецПроцедуры //ЗагрузитьНастройкиИзФайла()

// Процедура - Продолжение обработчика команды "ЗагрузитьНастройкиИзФайла"
//				после выполнения выбора файла для загрузки
//
// Параметры:
//  ВыбранныеФайлы		 - Массив		 - Имена выбранных файлов
//  Параметры			 - Структура	 - Параметры переданные из команды "ЗагрузитьНастройкиИзФайла"
//
&НаКлиенте
Процедура ЗагрузитьНастройкиИзФайлаОбработка(ВыбранныеФайлы, Параметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВремТекст = Новый ТекстовыйДокумент();
	ВремТекст.Прочитать(ВыбранныеФайлы[0]);
	
	Настройки = ПолучитьНастройкиИзТекста(ВремТекст.ПолучитьТекст());
	
	Если ТипЗнч(Настройки) = Тип("Структура") Тогда
		Настройки.Свойство("ИмяТаблицыСУБД"					, ИмяТаблицыСУБД);
			
		Попытка
			ЗаполнитьТаблицуИзМассиваСтруктур("ЗаполнениеПолей", Настройки.ЗаполнениеПолей);
		Исключение
		КонецПопытки;
		
		ФормаРедактированияЗапроса().УстановитьЗапросСПараметрами(Настройки);
			
	КонецЕсли;
	
КонецПроцедуры //ЗагрузитьНастройкиИзФайлаОбработка()

// Процедура - Обработчик команд "ЗагрузитьШаблон_*"
//
&НаКлиенте
Процедура ЗагрузитьНастройкиИзШаблона(Команда)
	
	ИмяМакета = Сред(Команда.Имя, 10);
	
	Настройки = ПолучитьНастройкиИзШаблонаНаСервере(ИмяМакета);
	
	Если ТипЗнч(Настройки) = Тип("Структура") Тогда
		Настройки.Свойство("ИмяТаблицыСУБД"					, ИмяТаблицыСУБД);
			
		Попытка
			ЗаполнитьТаблицуИзМассиваСтруктур("ЗаполнениеПолей", Настройки.ЗаполнениеПолей);
		Исключение
		КонецПопытки;
		
		ФормаРедактированияЗапроса().УстановитьЗапросСПараметрами(Настройки);
			
	КонецЕсли;
	
КонецПроцедуры //ЗагрузитьНастройкиИзШаблона()

// Процедура - Обработчик команды "ЗарегистрироватьИзменения"
//
&НаКлиенте
Процедура ЗарегистрироватьИзменения(Команда) Экспорт
	
	КолонкиЗапроса = ФормаРедактированияЗапроса().ПолучитьКолонкиЗапроса();
	
	ЗарегистрироватьИзмененияНаСервере(КолонкиЗапроса);
	
КонецПроцедуры //ЗарегистрироватьИзменения()

// Процедура - Обработчик команды "ВыгрузитьДанные"
//
&НаКлиенте
Процедура ВыгрузитьДанные(Команда) Экспорт
	
	ТекстОшибки = "";
	
	НастройкиПолученияДанных = ФормаРедактированияЗапроса().ПолучитьЗапросСПараметрами();

	ВыгрузитьДанныеНаСервере(НастройкиПолученияДанных, Истина, Ложь, , , ТекстОшибки);
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		Сообщить(ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры //ВыгрузитьДанные()

// Процедура - Обработчик команды "ВыгрузитьСкриптыВФайлы"
//
&НаКлиенте
Процедура ВыгрузитьСкриптыВФайлы(Команда) Экспорт
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Фильтр				= "Пакетный файл (*.bat)|*.bat|Все файлы (*.*)|*.*";
	Диалог.Расширение			= "bat";
	Диалог.МножественныйВыбор	= Ложь;
	
	ОповещениеВыбораФайла = Новый ОписаниеОповещения("ОбработатьВыборФайлаСкриптов", ЭтаФорма);
	
	Диалог.Показать(ОповещениеВыбораФайла);
	
КонецПроцедуры //ВыгрузитьСкриптыВФайлы()

// Процедура - Продолжение обработчика команды "ВыгрузитьСкриптыВФайлы"
//				после выполнения выбора файла для выгрузки
//
// Параметры:
//  ВыбранныеФайлы		 - Массив		 - Имена выбранных файлов
//  Параметры			 - Структура	 - Параметры переданные из команды "ВыгрузитьСкриптыВФайл"
//
&НаКлиенте
Процедура ОбработатьВыборФайлаСкриптов(ВыбранныеФайлы, Параметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСоединенияССУБД = ПолучитьПараметрыСоединенияССУБД(НастройкаСоединения);
	
	ВремФайл = Новый Файл(ВыбранныеФайлы[0]);
	
	ПутьКФайлуСкрипта = ВремФайл.Путь + ВремФайл.ИмяБезРасширения + "[[НомерФайла]].sql";
	
	ТекстКоманды = "sqlcmd -S " + ПараметрыСоединенияССУБД.Сервер +
						 " -d " + ПараметрыСоединенияССУБД.База +
						 " -U " + ПараметрыСоединенияССУБД.Пользователь +
						 " -P " + ПараметрыСоединенияССУБД.Пароль +
						 " -i ./" + ВремФайл.ИмяБезРасширения + "[[НомерФайла]].sql";
						 
	ЗаписьТекстаКоманд = Новый ЗаписьТекста(ВыбранныеФайлы[0], "windows-1251", , Ложь);
	ЗаписьТекстаКоманд.ЗаписатьСтроку("cd /D %~dp0");
	ЗаписьТекстаКоманд.Закрыть();
	
	КоличествоФайлов = 0;
	
	НастройкиПолученияДанных = ФормаРедактированияЗапроса().ПолучитьЗапросСПараметрами();
	
	Пока Истина Цикл
		АдресСкриптов = "";
		
		ТекстОшибки = "";
		
		ВыгрузитьДанныеНаСервере(НастройкиПолученияДанных, Ложь, Истина, АдресСкриптов, Истина, ТекстОшибки);
		
		Если АдресСкриптов = "" Тогда
			Прервать;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			Сообщить(ТекстОшибки);
			Прервать;
		Иначе
			ДанныеСкриптов = ПолучитьИзВременногоХранилища(АдресСкриптов);
		
			ЗаписьТекстаКоманд = Новый ЗаписьТекста(ВыбранныеФайлы[0], "windows-1251", , Истина);
			
			Для Каждого ТекСкрипт Из ДанныеСкриптов Цикл
			
				КоличествоФайлов = КоличествоФайлов + 1;
				
				ТекСкрипт.Записать(СтрЗаменить(ПутьКФайлуСкрипта, "[[НомерФайла]]", Формат(КоличествоФайлов, "ЧГ=0")));
				
				ЗаписьТекстаКоманд.ЗаписатьСтроку(СтрЗаменить(ТекстКоманды, "[[НомерФайла]]", Формат(КоличествоФайлов, "ЧГ=0")));
														
			КонецЦикла;
		
			ЗаписьТекстаКоманд.Закрыть();
	
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры //ОбработатьВыборФайлаСкриптов()

#КонецОбласти

#Область ПроцедурыПодготовкиЗаполненияПолей

// Процедура - Обновляет список колонок запроса для выбора
//
&НаКлиенте
Процедура ОбновитьСписокКолонокЗапроса()
	
	Элементы.ЗаполнениеПолейКолонкаЗапроса.СписокВыбора.Очистить();
	
	КолонкиЗапроса = ФормаРедактированияЗапроса().ПолучитьКолонкиЗапроса();
	
	Для Каждого ТекКолонка Из КолонкиЗапроса Цикл
		Элементы.ЗаполнениеПолейКолонкаЗапроса.СписокВыбора.Добавить(ТекКолонка.Имя);
	КонецЦикла;
	
КонецПроцедуры //ОбновитьСписокКолонокЗапроса()

// Процедура - Обновляет список таблиц внешней СУБД для выбора
//
&НаСервере
Процедура ОбновитьСписокТаблицНаСервере()
	
	Элементы.ИмяТаблицыСУБД.СписокВыбора.Очистить();
	Элементы.ЗаполнениеПолейТаблицаИсточник.СписокВыбора.Очистить();
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	Соединение = Неопределено;
	
	ТекстОшибки = "";
	
	Если НЕ ОбработкаОбъект.ПолучитьСоединениеССУБД(НастройкаСоединения.Драйвер
												  , НастройкаСоединения.Сервер
												  , НастройкаСоединения.ИмяБазы
												  , НастройкаСоединения.Пользователь
												  , НастройкаСоединения.Пароль
												  , Соединение
												  , ТекстОшибки) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапросаКСУБД = "USE [" + НастройкаСоединения.ИмяБазы + "];
						|
						|SELECT
						|	Tables.name AS name
						|
						|FROM sys.tables AS Tables
						|
						|WHERE type_desc = 'USER_TABLE'";
	
	РезультатЗапроса  = Неопределено;
	
	Если НЕ ОбработкаОбъект.ВыполнитьЗапросКСУБД(Соединение, ТекстЗапросаКСУБД, РезультатЗапроса, ТекстОшибки) Тогда
		Возврат;
	КонецЕсли;
	
	Пока РезультатЗапроса.EOF = 0 Цикл
			
		Для Каждого ТекКолонка Из РезультатЗапроса.Fields Цикл
			Если НЕ ВРег(ТекКолонка.Name) = ВРег("name") Тогда
				Продолжить;
			КонецЕсли;
			
			Элементы.ИмяТаблицыСУБД.СписокВыбора.Добавить(ТекКолонка.Value);
			Элементы.ЗаполнениеПолейТаблицаИсточник.СписокВыбора.Добавить(ТекКолонка.Value);
			
			Прервать;

		КонецЦикла;
			
		РезультатЗапроса.MoveNext();
	КонецЦикла;
	
КонецПроцедуры //ОбновитьСписокТаблицНаСервере()

// Процедура - Обновляет список колонок таблицы внешней СУБД для выбора
//
&НаСервере
Процедура ОбновитьСписокПолейСУБДНаСервере()
	
	Элементы.ЗаполнениеПолейКолонкаСУБД.СписокВыбора.Очистить();
	
	МассивПолей = ПолучитьСписокПолейТаблицыСУБДНаСервере(ИмяТаблицыСУБД);
	
	Для Каждого ТекПоле Из МассивПолей Цикл
			
		Элементы.ЗаполнениеПолейКолонкаСУБД.СписокВыбора.Добавить(ТекПоле);
	КонецЦикла;
	
КонецПроцедуры //ОбновитьСписокПолейСУБДНаСервере()

// Функция - Получает список колонок таблицы внешней СУБД для выбора
//
// Параметры:
//  БазаСУБД					 - Строка			 - Имя базы
//  ТаблицаСУБД					 - Строка			 - Имя таблицы
// 
// Возвращаемое значение:
//		Массив (Строка)		 - Имена полей таблицы
//
&НаСервере
Функция ПолучитьСписокПолейТаблицыСУБДНаСервере(ТаблицаСУБД) Экспорт
	
	МассивПолей = Новый Массив();
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	Соединение = Неопределено;
	
	ТекстОшибки = "";
	
	Если НЕ ОбработкаОбъект.ПолучитьСоединениеССУБД(НастройкаСоединения.Драйвер
												  , НастройкаСоединения.Сервер
												  , НастройкаСоединения.ИмяБазы
												  , НастройкаСоединения.Пользователь
												  , НастройкаСоединения.Пароль
												  , Соединение
												  , ТекстОшибки) Тогда
		Возврат МассивПолей;
	КонецЕсли;
	
	ТекстЗапросаКСУБД = "USE [" + НастройкаСоединения.ИмяБазы + "];
						|
						|SELECT
						|	Columns.COLUMN_NAME AS name
						|
						|FROM information_schema.columns AS Columns
						|
						|WHERE Columns.TABLE_NAME = '" + ТаблицаСУБД + "'";
	
	РезультатЗапроса  = Неопределено;
	
	Если НЕ ОбработкаОбъект.ВыполнитьЗапросКСУБД(Соединение, ТекстЗапросаКСУБД, РезультатЗапроса, ТекстОшибки) Тогда
		Возврат МассивПолей;
	КонецЕсли;
	
	Пока РезультатЗапроса.EOF = 0 Цикл
			
		Для Каждого ТекКолонка Из РезультатЗапроса.Fields Цикл
			Если НЕ ВРег(ТекКолонка.Name) = ВРег("name") Тогда
				Продолжить;
			КонецЕсли;
			
			МассивПолей.Добавить(ТекКолонка.Value);
			
			Прервать;

		КонецЦикла;
			
		РезультатЗапроса.MoveNext();
	КонецЦикла;
	
	Возврат МассивПолей;
	
КонецФункции //ПолучитьСписокПолейТаблицыСУБДНаСервере()

#КонецОбласти

#Область ПроцедурыОбработкиДанных

// Процедура - Выполняет регистрацию изменений, указанных данных
//			   в узле плана обмена, указанного в реквизите "УзелКонтроляИзменений"
//
// Параметры:
//  КолонкиЗапроса		 - Массив	 - Список колонок запроса, для значений которых нужно зарегистрировать изменения
//
&НаСервере
Процедура ЗарегистрироватьИзмененияНаСервере(КолонкиЗапроса)
	
	Если НЕ ЗначениеЗаполнено(УзелКонтроляИзменений) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекКолонка Из КолонкиЗапроса Цикл
		НайденныеСтроки = ЗаполнениеПолей.НайтиСтроки(Новый Структура("КолонкаЗапроса", ТекКолонка.Имя));
		
		Если НайденныеСтроки.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ НайденныеСтроки[0].ПолеСсылки Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ТекТип Из ТекКолонка.ТипЗначения.Типы() Цикл
			МетаОбъект = Метаданные.НайтиПоТипу(ТекТип);
			
			Если МетаОбъект = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ПланыОбмена.ЗарегистрироватьИзменения(УзелКонтроляИзменений, МетаОбъект);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры //ЗарегистрироватьИзмененияНаСервере()

// Функция - Возвращает параметры соединения с СУБД, указанные в справочнике настроек соединения
//
// Параметры:
//  НастройкаСоединения			 - СправочникСсылка.ктв_НастройкиПодключенияКСУБД	- Настройка настройка соединения
// 
// Возвращаемое значение:
//   - Структура
//			Драйвер			- Строка		- Наименование драйвера для подключения к серверу СУБД
//			Сервер			- Строка		- Адрес сервера\имя экземпляра MS SQL Server
//			База			- Строка		- Имя базы
//			Пользователь	- Строка		- Имя пользователя
//			Пароль			- Строка		- Пароль пользователя
//
&НаСервереБезКонтекста
Функция ПолучитьПараметрыСоединенияССУБД(НастройкаСоединения)
	
	Возврат Новый Структура("Драйвер, Сервер, База, Пользователь, Пароль"
						  , НастройкаСоединения.Драйвер
						  , НастройкаСоединения.Сервер
						  , НастройкаСоединения.ИмяБазы
						  , НастройкаСоединения.Пользователь
						  , НастройкаСоединения.Пароль);
	
КонецФункции //ПолучитьПараметрыСоединенияССУБД()

// Процедура - Выгрузить данные на сервере
//
// Параметры:
//  НастройкиПолученияДанных			 - Структура				 - Настройки выполнения запроса к 1С
//  ВыгрузитьДанные						 - Булево					 - Истина - Выполняется выгрузка данных в СУБД, Ложь - в противном случае
//  СохранитьСкрипты					 - Булево					 - Истина - Выполняется выгрузка в файл скриптов загрузки данных,
//																	   Ложь - в противном случае
//  АдресСкриптов						 - Строка					 - Адрес временного хранилища для передачи подготовленных скриптов
//  ВыгружатьПорциямиВыборки			 - Булево					 - Истина - выгрузка будет выполняться порциями,
//																	   указанными в реквизите "КоличествоСтрокВВыборкеДанных"
//  ТекстОшибки							 - Строка					 - Описание возникшей ошибки
//
&НаСервере
Процедура ВыгрузитьДанныеНаСервере(НастройкиПолученияДанных
								 , ВыгрузитьДанные = Истина
								 , СохранитьСкрипты = Ложь
								 , АдресСкриптов = ""
								 , ВыгружатьПорциямиВыборки = Ложь
								 , ТекстОшибки = "")
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	СоответствиеКолонок = ТаблицуВМассивСтруктур(ЗаполнениеПолей.Выгрузить());
	
	ОбработкаОбъект.ДополнитьОписаниеКолонокОписаниемТипов(НастройкаСоединения, ИмяТаблицыСУБД, СоответствиеКолонок);
	
	ТекстСписокПолейДляЗагрузки = "";
	
	ШаблонЗапросаКСУБД = ОбработкаОбъект.ПолучитьТекстЗапросаКСУБД(ИмяТаблицыСУБД
																 , СоответствиеКолонок
																 , ТекстСписокПолейДляЗагрузки);
	
	МассивФайлов = Новый Массив();
	
	ТекстОшибки = "";
	
	ПроцессорЗапросов = Обработки.ктв_сб_ПроцессорЗапросов.Создать();
	
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("Источник", Неопределено);
	ДопПараметры.Вставить("УзелКонтроляИзменений", УзелКонтроляИзменений);
	
	ОбработаноСтрокВсего = 0;
	
	Пока Истина Цикл
		Попытка
			РезультатЗапроса = ПроцессорЗапросов.ВыполнитьЗапрос(НастройкиПолученияДанных.Запрос_Текст
																, НастройкиПолученияДанных.Запрос_Параметры
																, КоличествоСтрокВВыборкеДанных
																, НастройкиПолученияДанных.ПроизвольныеВыражения
																, ДопПараметры
																, Ложь
																, ТекстОшибки);
		Исключение
			ТекстОшибки = "Ошибка запроса 1С: ";
			ТекстОшибки = ТекстОшибки + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			Возврат;
		КонецПопытки;
		
		Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
			ТекстОшибки = "Ошибка запроса 1С: " + ТекстОшибки;
			Возврат;
		КонецЕсли;
		
		Если РезультатЗапроса.Пустой() Тогда
			Прервать;
		КонецЕсли;
		
		ТаблицаКВыгрузке = РезультатЗапроса.Выгрузить();
		
		ВсегоСтрок = ТаблицаКВыгрузке.Количество();
		ОбработаноСтрок = 0;
		
		Попытка
			ЗапросыКСУБД = ОбработкаОбъект.ПодготовитьДанныеДляВыгрузки(ШаблонЗапросаКСУБД
																	  , ТаблицаКВыгрузке
																	  , СоответствиеКолонок
																	  , ТекстСписокПолейДляЗагрузки
																	  , КоличествоСтрокВТранзакцииСУБД
																	  , ОбработаноСтрок);
			
		Исключение
			ТекстОшибки = "Ошибка подготовки запросов к СУБД: ";
			ТекстОшибки = ТекстОшибки + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			Сообщить(ТекстОшибки);
			Возврат;
		КонецПопытки;
		
		Если ВыгрузитьДанные Тогда
			Соединение = Неопределено;
			
			Если НЕ ОбработкаОбъект.ПолучитьСоединениеССУБД(НастройкаСоединения.Драйвер
														  , НастройкаСоединения.Сервер
														  , НастройкаСоединения.ИмяБазы
														  , НастройкаСоединения.Пользователь
														  , НастройкаСоединения.Пароль
														  , Соединение
														  , ТекстОшибки) Тогда
				ТекстОшибки = "Ошибка соединения с СУБД: "
							+ Символы.ПС
							+ ТекстОшибки;
				Возврат;
			КонецЕсли;
		
			Результат = ОбработкаОбъект.ОбработатьМассивЗапросовКСУБД(Соединение, ЗапросыКСУБД, УзелКонтроляИзменений, ТекстОшибки);
		
			Если НЕ Результат = Истина Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		ОбработаноСтрокВсего = ОбработаноСтрокВсего + ОбработаноСтрок;

		Если СохранитьСкрипты Тогда
			Для Каждого ТекЗапрос Из ЗапросыКСУБД Цикл
				ВремИмяФайла = ПолучитьИмяВременногоФайла("sql");
				
				ВремТекст = Новый ТекстовыйДокумент();
				ВремТекст.УстановитьТипФайла(КодировкаТекста.UTF8);
				ВремТекст.УстановитьТекст(ТекЗапрос.Запрос);
				ВремТекст.Записать(ВремИмяФайла);
				
				МассивФайлов.Добавить(ВремИмяФайла);
				
				Если ЗначениеЗаполнено(УзелКонтроляИзменений) Тогда
					Для Каждого ТекСсылка Из ТекЗапрос.Ссылки Цикл
						ПланыОбмена.УдалитьРегистрациюИзменений(УзелКонтроляИзменений, ТекСсылка);
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если КоличествоСтрокВВыборкеДанных = 0 ИЛИ ТаблицаКВыгрузке.Количество() < КоличествоСтрокВВыборкеДанных ИЛИ ВыгружатьПорциямиВыборки Тогда
			Прервать;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(УзелКонтроляИзменений) Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ОбработаноСтрокВсего = 0 Тогда
		АдресСкриптов = "";
		Возврат;
	КонецЕсли;
	
	Если СохранитьСкрипты Тогда
		МассивДанных = Новый Массив();
	
		Для Каждого ТекФайл Из МассивФайлов Цикл
			ВремДанные = Новый ДвоичныеДанные(ТекФайл);
			МассивДанных.Добавить(ВремДанные);
		КонецЦикла;
		
		АдресСкриптов = ПоместитьВоВременноеХранилище(МассивДанных, ЭтаФорма.УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры //ВыгрузитьДанныеНаСервере()

#КонецОбласти

#Область СлужебныеПроцедуры

// Функция - Получает форму редактирования запросов
// 
// Возвращаемое значение:
//		УправляемаяФорма - Форма редактирования запроса
//
&НаКлиенте
Функция ФормаРедактированияЗапроса() Экспорт
	
	Если ФормаРедактированияЗапроса = Неопределено Тогда
		СтруктураПараметров = Новый Структура("Запрос_Текст, Запрос_Параметры, ПроизвольныеВыражения", "", Неопределено, Неопределено);
		
		Попытка
			Настройки = ПолучитьИзВременногоХранилища(ОбработкаНастройкиАдресВХранилище);
		Исключение
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			Настройки = Новый Структура();
		КонецПопытки;
		
		Если ТипЗнч(Настройки) = Тип("Структура") Тогда
			
			Если Настройки.Свойство("Запрос_Текст") Тогда
				СтруктураПараметров.Запрос_Текст = Настройки.Запрос_Текст;
			КонецЕсли;
				
			Если Настройки.Свойство("Запрос_Параметры") Тогда
				СтруктураПараметров.Запрос_Параметры = Настройки.Запрос_Параметры;
			КонецЕсли;
			
			Если Настройки.Свойство("ПроизвольныеВыражения") Тогда
				СтруктураПараметров.ПроизвольныеВыражения = Настройки.ПроизвольныеВыражения;
			КонецЕсли;
			
		КонецЕсли;
		
		ФормаРедактированияЗапроса = ПолучитьФорму("Обработка.ктв_сб_ПроцессорЗапросов.Форма.Форма", СтруктураПараметров, ЭтаФорма);
	КонецЕсли;
	
	Возврат ФормаРедактированияЗапроса;
	
КонецФункции //ФормаРедактированияЗапроса()

// Процедура - Для описанных в обработке шаблонов настроек
//			   создает соответствующие команты загрузки настроек из шаблона
//
&НаСервере
Процедура ПодготовитьШаблоныНастроек()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	Для Каждого ТекМакет Из ОбработкаОбъект.Метаданные().Макеты Цикл
		Если НЕ Лев(ТекМакет.Имя, 7) = "Шаблон_" Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ТекМакет.ТипМакета = Метаданные.СвойстваОбъектов.ТипМакета.ТекстовыйДокумент Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяКоманда = Команды.Добавить("Загрузить" + ТекМакет.Имя);
		НоваяКоманда.Действие = "ЗагрузитьНастройкиИзШаблона";
		НоваяКоманда.Заголовок = "Загрузить шаблон: """ + ТекМакет.Синоним + """";
		
		НоваяКнопка = Элементы.Добавить("Загрузить" + ТекМакет.Имя, Тип("КнопкаФормы"), Элементы.ФормаГруппаШаблоныНастроек);
		НоваяКнопка.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
		НоваяКнопка.ИмяКоманды = "Загрузить" + ТекМакет.Имя;
		НоваяКнопка.ТолькоВоВсехДействиях = Истина;
	КонецЦикла;
	
КонецПроцедуры //ПодготовитьШаблоныНастроек()

// Функция - Получить настройки из шаблона на сервере
//
// Параметры:
//  ИмяМакета				 - Строка			 - Имя макета с шаблоном настроек
// 
// Возвращаемое значение:
//		Структура			 - Структура настроек обработки
//
&НаСервере
Функция ПолучитьНастройкиИзШаблонаНаСервере(ИмяМакета)
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	Макет = ОбработкаОбъект.ПолучитьМакет(ИмяМакета);
	
	Возврат ЗначениеИзСтрокиВнутр(Макет.ПолучитьТекст());
	
КонецФункции //ПолучитьНастройкиИзШаблонаНаСервере()

// Процедура - Подготавливает настройки обработки к сохранению
//
// Параметры:
//  ДополнительныеНастройки			 - Структура		 - Дополнительные настройки, которые необходимо сохранить
//  СохранениеВФайл					 - Булево			 - Истина - Настройки сохраняются в файл (не нужно сохранять настройки,
//															специфичные для ИБ); Ложь - настройки сохраняются в ИБ
//
&НаСервере
Функция ПодготовитьНастройкиДляСохранения(ДополнительныеНастройки = Неопределено, СохранениеВФайл = Ложь)
	
	Настройка = Новый Структура();
	Настройка.Вставить("ИмяТаблицыСУБД"					, ИмяТаблицыСУБД);
	Если НЕ СохранениеВФайл Тогда
		Настройка.Вставить("НастройкаСоединения"			, НастройкаСоединения);
		Настройка.Вставить("УзелКонтроляИзменений"			, УзелКонтроляИзменений);
		Настройка.Вставить("КоличествоСтрокВВыборкеДанных"	, КоличествоСтрокВВыборкеДанных);
		Настройка.Вставить("КоличествоСтрокВТранзакцииСУБД"	, КоличествоСтрокВТранзакцииСУБД);
		Настройка.Вставить("ОбработкаПустогоРезультатаЗапроса"	, ОбработкаПустогоРезультатаЗапроса);
	КонецЕсли;
	
	Настройка.Вставить("ЗаполнениеПолей"				, ТаблицуВМассивСтруктур(ЗаполнениеПолей.Выгрузить()));
	
	Если ТипЗнч(ДополнительныеНастройки) = Тип("Структура") Тогда
		Для Каждого ТекНастройка Из ДополнительныеНастройки Цикл
			Настройка.Вставить(ТекНастройка.Ключ, ТекНастройка.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Настройка;
	
КонецФункции //ПодготовитьНастройкиДляСохранения()

// Функция - Преобразует настройки в текст на сервере
//
&НаСервереБезКонтекста
Функция ПолучитьТекстНастроекДляСохранения(Настройки)
	
	Возврат ЗначениеВСтрокуВнутр(Настройки);
	
КонецФункции //ПолучитьТекстНастроекДляСохранения()

// Функция - Преобразует текст в настройки на сервере
//
&НаСервереБезКонтекста
Функция ПолучитьНастройкиИзТекста(ТекстНастроек)
	
	Возврат ЗначениеИзСтрокиВнутр(ТекстНастроек);
	
КонецФункции //ПолучитьНастройкиИзТекста()

//Функция - Преобразует реквизит типа "ТаблицаЗначений" в массив структур
//
// Параметры:
//  ТЗ						 - Строка	 - Путь к реквизиту
// 
// Возвращаемое значение:
//  Массив(Структура) - Результат преобразования
//
&НаСервере
Функция ТаблицуВМассивСтруктурНаСервере(ТЗ) Экспорт
	
	Таблица = Вычислить(ТЗ);
	
	Возврат ТаблицуВМассивСтруктур(Таблица.Выгрузить());
	
КонецФункции //ТаблицуВМассивСтруктурНаСервере()

//Функция - Преобразует таблицу значений в массив структур
//
// Параметры:
//  ТЗ						 - ТаблицаЗначений	 - Таблица значений для преобразования
// 
// Возвращаемое значение:
//  Массив(Структура) - Результат преобразования
//
&НаКлиентеНаСервереБезКонтекста
Функция ТаблицуВМассивСтруктур(ТЗ) Экспорт
	
	Результат = Новый Массив();
	
	Для Каждого ТекСтрока Из ТЗ Цикл
		
		НоваяСтрока = Новый Структура();
		
		Для Каждого ТекКолонка Из ТЗ.Колонки Цикл
			НоваяСтрока.Вставить(ТекКолонка.Имя, ТекСтрока[ТекКолонка.Имя]);
		КонецЦикла;
		
		Результат.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции //ТаблицуВМассивСтруктур()

//Функция - заполняет переданную таблицу из массива структур
//
// Параметры:
//  Таблица					 - ТаблицаЗначений,		 - Таблица для заполнения
//							   ДанныеФормыКоллекция
//  МС						 - Массив(Структура)	 - Массив структур для преобразования
// 
&НаСервере
Процедура ЗаполнитьТаблицуИзМассиваСтруктур(Знач Таблица, МС)
	
	Если НЕ ТипЗнч(МС) = Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Если МС.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ТипЗнч(МС[0]) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Таблица) = Тип("Строка") Тогда
		ТаблицаДляЗаполнения = РеквизитФормыВЗначение(Таблица);
	Иначе
		ТаблицаДляЗаполнения = Таблица;
	КонецЕсли;
	
	ТаблицаДляЗаполнения.Очистить();
	
	Для Каждого ТекЭлемент Из МС Цикл
		Если НЕ ТипЗнч(ТекЭлемент) = Тип("Структура") Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ТаблицаДляЗаполнения.Добавить();
		Попытка
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекЭлемент);
		Исключение
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		
	КонецЦикла;
	
	Если ТипЗнч(Таблица) = Тип("Строка") Тогда
		ЗначениеВРеквизитФормы(ТаблицаДляЗаполнения, Таблица);
	КонецЕсли;
	
КонецПроцедуры //ЗаполнитьТаблицуИзМассиваСтруктур()

// Функция - Получает текст запроса SQL
//
// Параметры:
//  НастройкиПолученияДанных		- Структура			 - Настройки получения данных из формы редактирования запроса
// 
// Возвращаемое значение:
//   Строка	- Такст запроса SQL
//
&НаСервере
Функция ПолучитьТекстЗапросаСКЛНаСервере(НастройкиПолученияДанных)
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	СоответствиеКолонок = ТаблицуВМассивСтруктур(ЗаполнениеПолей.Выгрузить());
	
	ОбработкаОбъект.ДополнитьОписаниеКолонокОписаниемТипов(НастройкаСоединения, ИмяТаблицыСУБД, СоответствиеКолонок);
	
	ТекстСписокПолейДляЗагрузки = "";
	
	ШаблонЗапросаКСУБД = ОбработкаОбъект.ПолучитьТекстЗапросаКСУБД(ИмяТаблицыСУБД
																 , СоответствиеКолонок
																 , ТекстСписокПолейДляЗагрузки);
	
	ТекстОшибки = "";
	
	ПроцессорЗапросов = Обработки.ктв_сб_ПроцессорЗапросов.Создать();
	
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("Источник", Неопределено);
	ДопПараметры.Вставить("УзелКонтроляИзменений", УзелКонтроляИзменений);
	
	ОбработаноСтрокВсего = 0;
	
	Попытка
		РезультатЗапроса = ПроцессорЗапросов.ВыполнитьЗапрос(НастройкиПолученияДанных.Запрос_Текст
															, НастройкиПолученияДанных.Запрос_Параметры
															, 1
															, НастройкиПолученияДанных.ПроизвольныеВыражения
															, ДопПараметры
															, Ложь
															, ТекстОшибки);
	Исключение
		ТекстОшибки = "Ошибка запроса 1С: ";
		ТекстОшибки = ТекстОшибки + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Сообщить(ТекстОшибки);
		Возврат "";
	КонецПопытки;
	
	Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
		ТекстОшибки = "Ошибка запроса 1С: " + ТекстОшибки;
		Сообщить(ТекстОшибки);
		Возврат "";
	КонецЕсли;
	
	Если РезультатЗапроса.Пустой() Тогда
		ТекстОшибки = "Ошибка запроса 1С: получен пустой результат запроса" + ТекстОшибки;
		Сообщить(ТекстОшибки);
	КонецЕсли;
	
	ТаблицаКВыгрузке = РезультатЗапроса.Выгрузить();
	
	ВсегоСтрок = ТаблицаКВыгрузке.Количество();
	ОбработаноСтрок = 0;
	
	Попытка
		ЗапросыКСУБД = ОбработкаОбъект.ПодготовитьДанныеДляВыгрузки(ШаблонЗапросаКСУБД
																  , ТаблицаКВыгрузке
																  , СоответствиеКолонок
																  , ТекстСписокПолейДляЗагрузки
																  , КоличествоСтрокВТранзакцииСУБД
																  , ОбработаноСтрок);
		
	Исключение
		ТекстОшибки = "Ошибка подготовки запросов к СУБД: ";
		ТекстОшибки = ТекстОшибки + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Сообщить(ТекстОшибки);
		Возврат "";
	КонецПопытки;
	
	Возврат ?(ВсегоСтрок = 0, ШаблонЗапросаКСУБД, ЗапросыКСУБД[0].Запрос);
	
КонецФункции //ПолучитьТекстЗапросаСКЛНаСервере()

#КонецОбласти
