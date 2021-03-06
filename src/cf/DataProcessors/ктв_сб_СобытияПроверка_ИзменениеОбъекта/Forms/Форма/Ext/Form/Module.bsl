﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОбработкаНастройкиАдресВХранилище") Тогда
		ОбработкаНастройкиАдресВХранилище = Параметры.ОбработкаНастройкиАдресВХранилище;
	
		Настройки = ПолучитьИзВременногоХранилища(ОбработкаНастройкиАдресВХранилище);
	
		Если ТипЗнч(Настройки) = Тип("Структура") Тогда
			СохраненныеРеквизитыОбъектов = Новый Соответствие();
			Если Настройки.Свойство("РеквизитыОбъектов") Тогда
				СохраненныеРеквизитыОбъектов = Настройки.РеквизитыОбъектов;
			КонецЕсли;
						
			Если НЕ ТипЗнч(СохраненныеРеквизитыОбъектов) = Тип("Соответствие") Тогда
				СохраненныеРеквизитыОбъектов = Новый Соответствие();
			КонецЕсли;
			
			Для Каждого ТекОбъект Из СохраненныеРеквизитыОбъектов Цикл
				
				НоваяСтрока = РеквизитыОбъектов.Добавить();
				НоваяСтрока.ТипОбъекта					= ТекОбъект.Ключ;
				НоваяСтрока.ПроверяемыеРеквизиты		= Новый СписокЗначений();
				НоваяСтрока.ИсключаемыеРеквизиты		= Новый СписокЗначений();
				НоваяСтрока.ПроверяемыеТолькоОтмеченные	= Ложь;
				НоваяСтрока.ИсключаемыеТолькоОтмеченные	= Ложь;
				НоваяСтрока.ПередатьДляОбработки		= Ложь;
				
				Если ТекОбъект.Значение.Свойство("ПередатьДляОбработки") Тогда
					НоваяСтрока.ПередатьДляОбработки = ТекОбъект.Значение.ПередатьДляОбработки;
				КонецЕсли;
				
				СписокРеквизитов = ПолучитьСписокРеквизитовНаСервере(ТекОбъект.Ключ);
			
				Для Каждого ТекЭлемент Из СписокРеквизитов Цикл
					НоваяСтрока.ПроверяемыеРеквизиты.Добавить(ТекЭлемент.Значение, ТекЭлемент.Представление, НЕ ТекОбъект.Значение.ПроверяемыеРеквизиты.Найти(ТекЭлемент.Значение) = Неопределено);
					НоваяСтрока.ПроверяемыеТолькоОтмеченные = ?(НЕ НоваяСтрока.ПроверяемыеТолькоОтмеченные, (НЕ ТекОбъект.Значение.ПроверяемыеРеквизиты.Найти(ТекЭлемент.Значение) = Неопределено), Истина);
					НоваяСтрока.ИсключаемыеРеквизиты.Добавить(ТекЭлемент.Значение, ТекЭлемент.Представление, НЕ ТекОбъект.Значение.ИсключаемыеРеквизиты.Найти(ТекЭлемент.Значение) = Неопределено);
					НоваяСтрока.ИсключаемыеТолькоОтмеченные = ?(НЕ НоваяСтрока.ИсключаемыеТолькоОтмеченные, (НЕ ТекОбъект.Значение.ИсключаемыеРеквизиты.Найти(ТекЭлемент.Значение) = Неопределено), Истина);
				КонецЦикла;
			КонецЦикла;
			
			ОбъектыДляОбработки = Новый Соответствие();
			Если Настройки.Свойство("ОбъектыДляОбработки") Тогда
				ОбъектыДляОбработки = Настройки.ОбъектыДляОбработки;
			КонецЕсли;
						
			Если НЕ ТипЗнч(ОбъектыДляОбработки) = Тип("Соответствие") Тогда
				ОбъектыДляОбработки = Новый Соответствие();
			КонецЕсли;
			
			Для Каждого ТекСтрока Из РеквизитыОбъектов Цикл
				Если ОбъектыДляОбработки[ТекСтрока.ТипОбъекта] = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				ТекСтрока.ПередатьДляОбработки = Истина;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура РеквизитыОбъектовПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ЗаполнитьРеквизитыОбъекта", 0.3, Истина);
	
КонецПроцедуры //РеквизитыОбъектовПриАктивизацииСтроки()

&НаКлиенте
Процедура РеквизитыОбъектовТипОбъектаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.РеквизитыОбъектов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ПроверяемыеРеквизиты.Очистить();
	ТекущиеДанные.ИсключаемыеРеквизиты.Очистить();
		
	СписокРеквизитов = ПолучитьСписокРеквизитовНаСервере(ТекущиеДанные.ТипОбъекта);
	
	Для Каждого ТекЭлемент Из СписокРеквизитов Цикл
		ТекущиеДанные.ПроверяемыеРеквизиты.Добавить(ТекЭлемент.Значение, ТекЭлемент.Представление);
		ТекущиеДанные.ИсключаемыеРеквизиты.Добавить(ТекЭлемент.Значение, ТекЭлемент.Представление);
	КонецЦикла;
	
	ЗаполнитьРеквизитыОбъекта();
	
КонецПроцедуры //РеквизитыОбъектовТипОбъектаПриИзменении()

&НаКлиенте
Процедура РеквизитыПометкаПриИзменении(Элемент)
	
	ТекущиеДанныеОбъект = Элементы.РеквизитыОбъектов.ТекущиеДанные;
	
	Если ТекущиеДанныеОбъект = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанныеРеквизит = Элемент.Родитель.ТекущиеДанные;
	
	Если ТекущиеДанныеРеквизит = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекЭлемент = ТекущиеДанныеОбъект[Элемент.Родитель.Имя].НайтиПоЗначению(ТекущиеДанныеРеквизит.Значение); 
	
	ТекЭлемент.Пометка = ТекущиеДанныеРеквизит.Пометка;
	
КонецПроцедуры //РеквизитыПометкаПриИзменении()

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
	
	СохраняемыеРеквизитыОбъектов = Новый Соответствие();
	ОбъектыДляОбработки = Новый Соответствие();
	Для Каждого ТекСтрока Из РеквизитыОбъектов Цикл
		НовыйОбъект = Новый Структура("ПередатьДляОбработки,
									  |ПроверяемыеРеквизиты,
									  |ИсключаемыеРеквизиты",
									  Ложь,
									  Новый Массив(),
									  Новый Массив());
		
		Для Каждого ТекЭлемент Из ТекСтрока.ПроверяемыеРеквизиты Цикл
			Если ТекЭлемент.Пометка Тогда
				НовыйОбъект.ПроверяемыеРеквизиты.Добавить(ТекЭлемент.Значение);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ТекЭлемент Из ТекСтрока.ИсключаемыеРеквизиты Цикл
			Если ТекЭлемент.Пометка Тогда
				НовыйОбъект.ИсключаемыеРеквизиты.Добавить(ТекЭлемент.Значение);
			КонецЕсли;
		КонецЦикла;
		
		СохраняемыеРеквизитыОбъектов.Вставить(ТекСтрока.ТипОбъекта, НовыйОбъект);
		
		Если ТекСтрока.ПередатьДляОбработки Тогда
			НовыйОбъект.ПередатьДляОбработки = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Настройка.Вставить("РеквизитыОбъектов", СохраняемыеРеквизитыОбъектов);
	
	ПоместитьВоВременноеХранилище(Настройка, ОбработкаНастройкиАдресВХранилище);
	
КонецПроцедуры //СохранитьНастройкуНаСервере()

&НаКлиенте
Процедура ИсключаемыеПоказывать(Команда)
	
	ТекущиеДанные = Элементы.РеквизитыОбъектов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ИсключаемыеРеквизитыПоказывать.Пометка = НЕ Элементы.ИсключаемыеРеквизитыПоказывать.Пометка;
	
	ТекущиеДанные.ИсключаемыеТолькоОтмеченные = Элементы.ИсключаемыеРеквизитыПоказывать.Пометка;
	
	ЗаполнитьРеквизитыОбъекта();
	
КонецПроцедуры //ИсключаемыеПоказывать()

&НаКлиенте
Процедура ПроверяемыеПоказывать(Команда)
	
	ТекущиеДанные = Элементы.РеквизитыОбъектов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ПроверяемыеРеквизитыПоказывать.Пометка = НЕ Элементы.ПроверяемыеРеквизитыПоказывать.Пометка;
	
	ТекущиеДанные.ПроверяемыеТолькоОтмеченные = Элементы.ПроверяемыеРеквизитыПоказывать.Пометка;
	
	ЗаполнитьРеквизитыОбъекта();
	
КонецПроцедуры //ПроверяемыеПоказывать()

#КонецОбласти

#Область СлужебныеПроцедуры

// Функция - Получает список реквизитов заказа клиента
// 
// Возвращаемое значение:
//   СписокЗначений - Список реквизитов заказа клиента
//
&НаСервере
Функция ПолучитьСписокРеквизитовНаСервере(ИдентификаторОбъекта)
	
	СписокРеквизитов = Новый СписокЗначений();
	
	МетаОбъект = Метаданные.НайтиПоПолномуИмени(ИдентификаторОбъекта.ПолноеИмя);
	
	Для Каждого ТекРеквизит Из МетаОбъект.СтандартныеРеквизиты Цикл
		
		СписокРеквизитов.Добавить(ТекРеквизит.Имя, ?(ЗначениеЗаполнено(ТекРеквизит.Синоним), ТекРеквизит.Синоним, ТекРеквизит.Имя));
		
	КонецЦикла;
	
	Для Каждого ТекРеквизит Из МетаОбъект.Реквизиты Цикл
		
		СписокРеквизитов.Добавить(ТекРеквизит.Имя, ?(ЗначениеЗаполнено(ТекРеквизит.Синоним), ТекРеквизит.Синоним, ТекРеквизит.Имя));
		
	КонецЦикла;
	
	ДопРеквизиты = Неопределено;
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ЕстьДопРеквизиты = ОбработкаОбъект.ЕстьДопРеквизиты(ИдентификаторОбъекта, ДопРеквизиты);
	
	Для Каждого ТекТЧ Из МетаОбъект.ТабличныеЧасти Цикл
		
		Если ЕстьДопРеквизиты И ТекТч.Имя = "ДополнительныеРеквизиты" Тогда
			Продолжить;
		КонецЕсли;
			
		СписокРеквизитов.Добавить("__ТЧ_" + ТекТЧ.Имя
								, "ТЧ: " + ?(ЗначениеЗаполнено(ТекТЧ.Синоним)
								, ТекТЧ.Синоним
								, ТекТЧ.Имя));
		
		Для Каждого ТекРеквизит Из ТекТЧ.Реквизиты Цикл
				
			СписокРеквизитов.Добавить("__ТЧ_" + ТекТЧ.Имя + "_" + ТекРеквизит.Имя
									, ?(ЗначениеЗаполнено(ТекТЧ.Синоним), ТекТЧ.Синоним, ТекТЧ.Имя) + ": " + ?(ЗначениеЗаполнено(ТекРеквизит.Синоним)
									, ТекРеквизит.Синоним
									, ТекРеквизит.Имя));
				
		КонецЦикла;
		
	КонецЦикла;
	
	Если ЕстьДопРеквизиты И ТипЗнч(ДопРеквизиты) = Тип("Массив") Тогда
		
		Для Каждого ТекРеквизит Из ДопРеквизиты Цикл
			Если НЕ СписокРеквизитов.НайтиПоЗначению(ТекРеквизит) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			СписокРеквизитов.Добавить(СокрЛП(ТекРеквизит.УникальныйИдентификатор())
									, "Доп.: " + СокрЛП(ТекРеквизит));
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат СписокРеквизитов;
	
КонецФункции //ПолучитьСписокРеквизитовНаСервере()

&НаКлиенте
Процедура ЗаполнитьРеквизитыОбъекта()
	
	ПроверяемыеРеквизиты.Очистить();
	ИсключаемыеРеквизиты.Очистить();
	
	ТекущиеДанные = Элементы.РеквизитыОбъектов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ПроверяемыеРеквизитыПоказывать.Пометка = ТекущиеДанные.ПроверяемыеТолькоОтмеченные;
	Элементы.ИсключаемыеРеквизитыПоказывать.Пометка = ТекущиеДанные.ИсключаемыеТолькоОтмеченные;
	
	Для Каждого ТекРеквизит Из ТекущиеДанные.ПроверяемыеРеквизиты Цикл
		Если Элементы.ПроверяемыеРеквизитыПоказывать.Пометка И НЕ ТекРеквизит.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		ПроверяемыеРеквизиты.Добавить(ТекРеквизит.Значение, ТекРеквизит.Представление, ТекРеквизит.Пометка);
	КонецЦикла;
	
	Для Каждого ТекРеквизит Из ТекущиеДанные.ИсключаемыеРеквизиты Цикл
		Если Элементы.ИсключаемыеРеквизитыПоказывать.Пометка И НЕ ТекРеквизит.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		ИсключаемыеРеквизиты.Добавить(ТекРеквизит.Значение, ТекРеквизит.Представление, ТекРеквизит.Пометка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПоПлануОбменаНаСервере()
	
	РеквизитыОбъектов.Очистить();
	Для Каждого Документ Из Метаданные.Документы Цикл
	
		Если Метаданные.ПланыОбмена.ОбменУправлениеТорговлейБухгалтерияПредприятия.Состав.Найти(Документ) <> Неопределено Тогда
			
			ТекущиеДанные = РеквизитыОбъектов.Добавить();
			ТекущиеДанные.ТипОбъекта = Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоРеквизиту("ПолноеИмя",Документ.ПолноеИмя());
			
			ТекущиеДанные.ПроверяемыеРеквизиты.Очистить();
			ТекущиеДанные.ИсключаемыеРеквизиты.Очистить();
				
			СписокРеквизитов = ПолучитьСписокРеквизитовНаСервере(ТекущиеДанные.ТипОбъекта);
			
			Для Каждого ТекЭлемент Из СписокРеквизитов Цикл
				НоваяСтрока = ТекущиеДанные.ПроверяемыеРеквизиты.Добавить(ТекЭлемент.Значение, ТекЭлемент.Представление);
				НоваяСтрока.Пометка = Истина;
				ТекущиеДанные.ИсключаемыеРеквизиты.Добавить(ТекЭлемент.Значение, ТекЭлемент.Представление);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПоПлануОбмена(Команда)
	СформироватьПоПлануОбменаНаСервере();
КонецПроцедуры

#КонецОбласти

