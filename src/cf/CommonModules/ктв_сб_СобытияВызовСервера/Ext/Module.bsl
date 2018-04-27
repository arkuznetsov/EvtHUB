﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обработка событий (EventHUB)". (Передача обработки на сервер)
//
////////////////////////////////////////////////////////////////////////////////


#Область ОбработкаСобытий

// Функция - Получает описание события в виде структуры (для использования на клиенте)
//
// Параметры:
//  Событие				 - СправочникСсылка.ктв_сб_События		- Элемент справочника "События", для которого получаем описание
// 
// Возвращаемое значение:
//  Структура - Описание обработчика событий
//  	Ссылка					- СправочникСсылка	- Ссылка на элемент справочника
//  	Код						- Строка			- Код элемента справочника
//  	Наименование			- Строка			- Наименование элемента справочника
//  	Ид						- Строка(36)		- Идентификатор обработчика
//  	ОбработкаНастройки		- Структура			- Настройки обработки обслуживания обработчика события
//  	ОбработкаВнешняя		- Булево			- Истина - обработка внешняя
//  	ОбработкаИмяВстроенной	- Строка			- Имя объекта метаданных встроенной обработки
//
Функция ПолучитьОписаниеСобытия(Событие) Экспорт
	
	ОписаниеСобытия = Новый Структура();
	ОписаниеСобытия.Вставить("Ссылка"					, Событие.Ссылка);
	ОписаниеСобытия.Вставить("Код"						, Событие.Код);
	ОписаниеСобытия.Вставить("Наименование"				, Событие.Наименование);
	ОписаниеСобытия.Вставить("Ид"						, Событие.Ид);
	ОписаниеСобытия.Вставить("ОбработкаНастройки"		, Событие.ОбработкаНастройки.Получить());
	
	ВремОбработка = Событие.Обработа.Получить();
	ОбработкаВнешняя = (НЕ ТипЗнч(ВремОбработка) = Тип("Строка"));
	
	ОписаниеСобытия.Вставить("ОбработкаВнешняя"			, ОбработкаВнешняя);
	ОписаниеСобытия.Вставить("ОбработкаИмяВстроенной"	, ?(ОбработкаВнешняя, "", ВремОбработка));
	
	Возврат ОписаниеСобытия;
	
КонецФункции //ПолучитьОписаниеСобытия()

// Функция - Получает описание обработчика событий в виде структуры (для использования на клиенте)
//
// Параметры:
//  Обработчик			 - СправочникСсылка.				- Элемент справочника "Обработчики событий", для которого получаем описание
//							ктв_сб_СобытияОбработчики
// 
// Возвращаемое значение:
//  Структура - Описание обработчика событий
//  	Ссылка					- СправочникСсылка	- Ссылка на элемент справочника
//  	Код						- Строка			- Код элемента справочника
//  	Наименование			- Строка			- Наименование элемента справочника
//  	Ид						- Строка(36)		- Идентификатор обработчика
//  	ОбработкаНастройки		- Структура			- Настройки обработки обслуживания обработчика события
//  	ОбработкаВнешняя		- Булево			- Истина - обработка внешняя
//  	ОбработкаИмяВстроенной	- Строка			- Имя объекта метаданных встроенной обработки
//
Функция ПолучитьОписаниеОбработчикаСобытий(Обработчик) Экспорт
	
	ОписаниеОбработчика = Новый Структура();
	ОписаниеОбработчика.Вставить("Ссылка"					, Обработчик.Ссылка);
	ОписаниеОбработчика.Вставить("Код"						, Обработчик.Код);
	ОписаниеОбработчика.Вставить("Наименование"				, Обработчик.Наименование);
	ОписаниеОбработчика.Вставить("Ид"						, Обработчик.Ид);
	ОписаниеОбработчика.Вставить("ОбработкаНастройки"		, Обработчик.ОбработкаНастройки.Получить());
	
	ВремОбработка = Обработчик.Обработка.Получить();
	ОбработкаВнешняя = (НЕ ТипЗнч(ВремОбработка) = Тип("Строка"));
	
	ОписаниеОбработчика.Вставить("ОбработкаВнешняя"			, ОбработкаВнешняя);
	ОписаниеОбработчика.Вставить("ОбработкаИмяВстроенной"	, ?(ОбработкаВнешняя, "", ВремОбработка));
	
	Возврат ОписаниеОбработчика;
	
КонецФункции //ПолучитьОписаниеОбработчикаСобытий()

// Функция - Получает список обработчиков событий, которые необходимо выполнить на стороне клиента
// 
// Возвращаемое значение:
//  Массив(Структура) - Массив описаний обработчиков событий
//
Функция ПолучитьОбработчикиСобытийДляВыполненияНаКлиенте() Экспорт
	
	Возврат ктв_сб_События.ПолучитьОбработчикиСобытийДляВыполненияНаКлиенте();
	
КонецФункции //ПолучитьОбработчикиСобытийДляВыполненияНаКлиенте()

// Процедура - Записывает результат обработки события на стороне клиента
//
// Параметры:
//  ТочкаВозникновения	 - СправочникСсылка.
//							ктв_сб_СобытияТочкиВозникновения	- Точка (ИБ), где возникло событие
//  ИдСобытия			 - Строка							- Уникальный идентификатор события
//  Событие				 - СправочникСсылка.ктв_сб_События		- Возникшее событие
//  Обработчик			 - СправочникСсылка.				- Обработчик события
//							ктв_сб_СобытияОбработчики
//  Пользователь		 - СправочникСсылка.Пользователи	- Пользователь для которого выполнялась обработка события
//  Обработано			 - Булево							- Истина - Обработка события выполнена; Ложь - в противном случае
//  Ошибка				 - Булево							- Истина - В процессе выполнения обработки произошла ошибка; Ложь - в противном случае
//  ТекстОшибки			 - Строка							- Текст ошибки
//
Процедура ЗаписатьРезультатОбработкиСобытияНаКлиенте(ТочкаВозникновения = Неопределено
												   , ИдСобытия
												   , Событие = Неопределено
												   , Обработчик = Неопределено
												   , Пользователь = Неопределено
												   , Обработано = Неопределено
												   , Ошибка = Ложь
												   , ТекстОшибки = "") Экспорт
	
	ктв_сб_События.ЗаписатьРезультатОбработкиСобытияНаКлиенте(ТочкаВозникновения
														 , ИдСобытия
														 , Событие
														 , Обработчик
														 , Пользователь
														 , Обработано
														 , Ошибка
														 , ТекстОшибки);
	
КонецПроцедуры //ЗаписатьРезультатОбработкиСобытияНаКлиенте()

#КонецОбласти

#Область СлужебныеПроцедуры

// Функция - Получает идентификатор объекта метаданных
//
// Параметры:
//  ОписаниеОбъектаМетаданных	 - Тип, Строка, ОбъектМетаданных	 - Описание объекта для получения идентификатора
// 
// Возвращаемое значение:
//  СправочникСсылка.ИдентификаторыОбъектовМетаданных - Элемент справочника, идентификатор объекта
//
Функция ПолучитьИдентификаторОбъектаМетаданных(ОписаниеОбъектаМетаданных) Экспорт
	
	ТипОписанияОбъектаМетаданных = ТипЗнч(ОписаниеОбъектаМетаданных);
	Если ТипОписанияОбъектаМетаданных = Тип("Тип") Тогда
		
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ОписаниеОбъектаМетаданных);
		Если ОбъектМетаданных = Неопределено Тогда
			Возврат Неопределено;
		Иначе
			ПолноеИмяОбъектаМетаданных = ОбъектМетаданных.ПолноеИмя();
		КонецЕсли;
		
	ИначеЕсли ТипОписанияОбъектаМетаданных = Тип("Строка") Тогда
		ПолноеИмяОбъектаМетаданных = ОписаниеОбъектаМетаданных;
	Иначе
		ПолноеИмяОбъектаМетаданных = ОписаниеОбъектаМетаданных.ПолноеИмя();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПолноеИмя", ПолноеИмяОбъектаМетаданных);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Идентификаторы.Ссылка КАК Ссылка,
	|	Идентификаторы.КлючОбъектаМетаданных,
	|	Идентификаторы.ПолноеИмя
	|ИЗ
	|	Справочник.ИдентификаторыОбъектовМетаданных КАК Идентификаторы
	|ГДЕ
	|	Идентификаторы.ПолноеИмя = &ПолноеИмя
	|	И НЕ Идентификаторы.ПометкаУдаления";
	
	Результат = Запрос.Выполнить();
	
	Выгрузка = Результат.Выгрузить();
	
	Если Выгрузка.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Выгрузка[0].Ссылка;
	
КонецФункции //ПолучитьИдентификаторОбъектаМетаданных()

// Функция - Получает текущего пользователя
//
// Возвращаемое значение:
//  СправочникСсылка.Пользователи - Элемент справочника "Пользователи", соответствующий текущему пользователю
//
Функция ТекущийПользователь() Экспорт
	
	Возврат ктв_сб_События.ТекущийПользователь();
	
КонецФункции //ТекущийПользователь()

#КонецОбласти 
