﻿#Использовать tempfiles
#Использовать logos

Перем мКаталогВнешнихПрограмм;
Перем Лог;
Перем ЭтоWindows;

//////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Процедура ВыгрузитьВерсиюКонфигурации(Знач ФайлХранилища, Знач ВыходнойФайл, Знач НомерВерсии = 0) Экспорт

	ЛогTool1CD = ВременныеФайлы.НовоеИмяФайла("txt");
	ПрефиксПути = ?(ЭтоWindows = Ложь, "Z:", "");
	СтрокаЗапуска = """" + ПутьTool1CD() + """ """ + ПрефиксПути + ФайлХранилища 
					+ """ -l """ + ПрефиксПути +  ЛогTool1CD
					+ """ -q -ne -drc "
					+ Строка(НомерВерсии) 
					+" """ + ПрефиксПути + ВыходнойФайл +"""";
					
	ФайлИсходника = Новый Файл(ВыходнойФайл);
	ФайлЛога      = Новый Файл(ЛогTool1CD);
	
	КодВозврата = "";
	Если НЕ ЭтоWindows Тогда 
		СтрокаЗапуска = "wine "+СтрокаЗапуска;
	КонецЕсли;
	Лог.Отладка(СтрокаЗапуска);
	ЗапуститьПриложение(СтрокаЗапуска, "", Истина, КодВозврата);
	Если ФайлЛога.Существует() Тогда
		Лог.Отладка(ПрочитатьФайл(ЛогTool1CD));
	КонецЕсли;
	Если Не ФайлИсходника.Существует() Тогда
		ВызватьИсключение "Tool_1CD не выгрузил файл конфигурации.";
	КонецЕсли;
	
	Если КодВозврата <> 0 Тогда
		Лог.Ошибка(ПрочитатьФайл(ЛогTool1CD));
		ВызватьИсключение "Tool_1CD вернул код возврата " + КодВозврата;
	КонецЕсли;
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////////////////////
//

Функция ПутьTool1CD(Знач НовыйПуть = Неопределено)
	
	Возврат РасположениеTool1CD.ПутьTool1CD(НовыйПуть);
	
КонецФункции

Функция ПрочитатьФайл(Знач ИмяФайла)
	ЧтениеТекста = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF8NoBOM);
	Текст = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();
	
	Возврат Текст;
КонецФункции

СистемнаяИнформация = Новый СистемнаяИнформация;
ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;

Лог = Логирование.ПолучитьЛог("oscript.lib.tool1cd");
