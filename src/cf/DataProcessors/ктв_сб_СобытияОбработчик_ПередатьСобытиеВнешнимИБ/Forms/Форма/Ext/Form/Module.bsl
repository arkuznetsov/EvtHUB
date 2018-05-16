﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОбработкаНастройкиАдресВХранилище") Тогда
		ОбработкаНастройкиАдресВХранилище = Параметры.ОбработкаНастройкиАдресВХранилище;
	
		Настройки = ПолучитьИзВременногоХранилища(ОбработкаНастройкиАдресВХранилище);
	
		Если ТипЗнч(Настройки) = Тип("Структура") Тогда
			Попытка
				СобытияВнешнихИБДляПередачи.Загрузить(Настройки.СобытияВнешнихИБДляПередачи);
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры //ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

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
	Настройка.Вставить("СобытияВнешнихИБДляПередачи", СобытияВнешнихИБДляПередачи.Выгрузить());
	
	ПоместитьВоВременноеХранилище(Настройка, ОбработкаНастройкиАдресВХранилище);
	
КонецПроцедуры //СохранитьНастройкуНаСервере()

&НаКлиенте
Процедура ВнешниеИБДляПередачиСобытийСобытиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.СобытияВнешнихИБДляПередачи.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.ВнешняяСистема) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстОшибки = "";
	
	СтруктураНастроек =
		ктв_ОбщегоНазначенияРаботаССервисамиВызовСервера.ПолучитьНастройкиСоединенияДляТочки(ТекущиеДанные.ВнешняяСистема);
	
	СписокСобытий = ктв_сб_СобытияВызовСервера.ПолучитьСписокСобытийВнешнейИБ(СтруктураНастроек, ТекстОшибки);
	
	Если СписокСобытий.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СписокВыбора = Новый СписокЗначений();
	
	Для Каждого ТекСобытие Из СписокСобытий Цикл
		СписокВыбора.Добавить(ТекСобытие.Ид, ТекСобытие.Наименование);
	КонецЦикла;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораВнешнегоСобытия", ЭтаФорма, ТекущиеДанные);
	
	ПоказатьВыборИзМеню(ОписаниеОповещения, СписокВыбора, Элемент);
	
КонецПроцедуры //ВнешниеИБДляПередачиСобытийСобытиеНачалоВыбора()

&НаКлиенте
Процедура ОбработкаВыбораВнешнегоСобытия(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если НЕ ВыбранныйЭлемент = Неопределено Тогда
		ДополнительныеПараметры.ИдСобытия			= ВыбранныйЭлемент.Значение;
		ДополнительныеПараметры.НаименованиеСобытия	= ВыбранныйЭлемент.Представление;
	КонецЕсли;
	
КонецПроцедуры //ОбработкаВыбораВнешнегоСобытия()

#КонецОбласти
