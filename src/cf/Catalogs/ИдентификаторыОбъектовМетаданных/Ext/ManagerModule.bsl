﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура обновляет данные справочника по метаданным конфигурации.
//
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - в этот параметр возвращается
//                  значение Истина, если производилась запись, иначе не изменяется.
//
//  ЕстьУдаленные - Булево (возвращаемое значение) - в этот параметр возвращается
//                  значение Истина, если хотя бы один элемент справочника был помечен
//                  на удаление, иначе не изменяется.
//
//  ТолькоПроверка - Булево - не производить никаких изменений, а лишь выполнить
//                   установку флажков ЕстьИзменения, ЕстьУдаленные.
//
Процедура ОбновитьДанныеСправочника(ЕстьИзменения = Ложь, ЕстьУдаленные = Ложь, ТолькоПроверка = Ложь) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс


#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти

#КонецЕсли