﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЕстьПравоАдминистрирование = ПравоДоступа("Администрирование", Метаданные) и ПравоДоступа("АдминистрированиеДанных", Метаданные);
	Если Не ЕстьПравоАдминистрирование Тогда
		Сообщить(
			"Нет прав для редактирования списка пользователей. 
			|Нужны права «Администрирование» и «АдминистрированиеДанных»", 
			СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли; 
	
	ЗаполнитьСписокВыбораПользователей(); 
	
	ТаймаутПодменыПароля = Элементы.ТаймаутЗаменыПароля.МинимальноеЗначение;
	
	#Область ПодсказкаОсновныеРоли
	СоставПодсказки = Новый Массив;
	СоставПодсказки.Добавить("Будут временно предоставлены роли:");
	ЕстьРолиРасширений = Ложь;
	Для каждого Роль Из Метаданные.ОсновныеРоли Цикл
		Если Не ЗначениеЗаполнено(Роль.Синоним) Тогда
			ЕстьРолиРасширений = Истина;
			Продолжить;
		КонецЕсли; 
		СоставПодсказки.Добавить("- " + Роль.Синоним);
	КонецЦикла; 
	Если ЕстьРолиРасширений Тогда
		СоставПодсказки.Добавить("А также роли расширений");	
	КонецЕсли; 
	Элементы.ПредоставитьОсновныеРоли.Подсказка = СтрСоединить(СоставПодсказки, Символы.ПС);
	#КонецОбласти // ПодсказкаОсновныеРоли 
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	Настройки.Вставить("ДопПараметрыКоманднойСтрокиСписокВыбора", Элементы.ДопПараметрыКоманднойСтроки.СписокВыбора.Скопировать());
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)    
	ТаймаутПодменыПароля = Макс(ТаймаутПодменыПароля, Элементы.ТаймаутЗаменыПароля.МинимальноеЗначение);
	ПрочитатьСвойстваПользователя(ИмяПользователя);
	СохраняемоеЗначениеПароляВрем	 = СоздатьСохраняемоеЗначениеПароля(ПарольВременный);
	
	#Область ДопПараметрыКоманднойСтроки
	СписокВыбораИстория = Настройки["ДопПараметрыКоманднойСтрокиСписокВыбора"];
	Если ТипЗнч(СписокВыбораИстория) = Тип("СписокЗначений") Тогда
		СписокВыбора = Элементы.ДопПараметрыКоманднойСтроки.СписокВыбора;
		Для каждого ЭлементСпискаЗначений Из СписокВыбораИстория Цикл
			СписокВыбора.Добавить(ЭлементСпискаЗначений.Значение);			
		КонецЦикла; 
	КонецЕсли; 
	#КонецОбласти // ДопПараметрыКоманднойСтроки 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИмяПользователяПриИзменении(Элемент)
	ПрочитатьСвойстваПользователя(ИмяПользователя);
КонецПроцедуры

&НаКлиенте
Процедура ПарольВременныйПриИзменении(Элемент)
	СохраняемоеЗначениеПароляВрем = СоздатьСохраняемоеЗначениеПароля(ПарольВременный);
КонецПроцедуры

&НаКлиенте
Процедура ТаймаутЗаменыПароляРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	//СтандартнаяОбработка = Ложь;
	
	Шаг = 10;
	
	//ТаймаутПодменыПароля = Макс(
	//	МинТаймаутПодменыПароля, 
	//	ТаймаутПодменыПароля + Шаг * Направление);
	ТаймаутПодменыПароля = ТаймаутПодменыПароля + (Шаг - 1) * Направление;
	
КонецПроцедуры

&НаКлиенте
Процедура ДопПараметрыКоманднойСтрокиПриИзменении(Элемент)
	
	Значение = ДопПараметрыКоманднойСтроки;
	Если ПустаяСтрока(Значение) Тогда
		Возврат;
	КонецЕсли; 
	
	СписокВыбора = Элемент.СписокВыбора;
	
	ЗначениеСписка = СписокВыбора.НайтиПоЗначению(Значение);
	Если ЗначениеСписка = Неопределено Тогда
		СписокВыбора.Вставить(0, Значение);
	Иначе	
		ИндексЗначения = СписокВыбора.Индекс(ЗначениеСписка);
		СписокВыбора.Сдвинуть(ИндексЗначения, - ИндексЗначения);
	КонецЕсли; 
	
	МаксЭлементовСписка = 12;
	Пока СписокВыбора.Количество() > МаксЭлементовСписка Цикл
		СписокВыбора.Удалить(МаксЭлементовСписка);
	КонецЦикла;
	
	СохраняемыеВНастройкахДанныеМодифицированы = Истина;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовФормы

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодменитьПарольЗапуститьСистему(Команда)
	
	Если не ПроверитьНаличиеПользователяИнтерактивно() Тогда
		Возврат;
	КонецЕсли; 
	
	ПодменитьПарольВременно(Неопределено);
	ЗапуститьСистемуПодВременнымПаролем();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодменитьПарольВременно(Команда)
	
	Если не ПроверитьНаличиеПользователяИнтерактивно() Тогда
		Возврат;
	КонецЕсли; 
	
	ПодключитьОбработчикОжидания("ВосстановитьПарольНаКлиенте", ТаймаутПодменыПароля, Истина);
	ЭтаФорма.Доступность = Ложь;
	ПодменитьПарольНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьПароль(Команда)
	
	Если не ПроверитьНаличиеПользователяИнтерактивно() Тогда
		Возврат;
	КонецЕсли; 
	
	ВосстановитьПарольНаКлиенте();
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПроверитьНаличиеПользователяИнтерактивно()
	
	Если ПустаяСтрока(ИмяПользователя) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Имя пользователя не указано";
		Сообщение.Поле = "ИмяПользователя";
		Сообщение.Сообщить(); 
		Возврат Ложь;
	КонецЕсли; 

	Если Не ПользовательСуществует(ИмяПользователя) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтрШаблон("Пользователя %1 не существует", ИмяПользователя);
		Сообщение.Поле = "ИмяПользователя";
		Сообщение.Сообщить(); 
		ЗаполнитьСписокВыбораПользователей();
		Возврат Ложь;
	КонецЕсли; 
	
	Возврат Истина;

КонецФункции // ПроверитьНаличиеПользователяИнтерактивно()

&НаСервере
Процедура ЗаполнитьСписокВыбораПользователей()

	СписокВыбора = Элементы.ИмяПользователя.СписокВыбора;
	
	СохрЗначПустогоПароля = СоздатьСохраняемоеЗначениеПароля("");
	КартинкаПользователь						 = БиблиотекаКартинок.Пользователь;
	КартинкаПользовательСАутентификацией		 = БиблиотекаКартинок.ПользовательСАутентификацией;
	КартинкаПользовательБезНеобходимыхСвойств	 = БиблиотекаКартинок.ПользовательБезНеобходимыхСвойств;
	
	Для каждого Пользователь Из ПользователиИнформационнойБазы.ПолучитьПользователей() Цикл
		
		ПользователюРазрешенВход = 	Пользователь.АутентификацияСтандартная 
									Или Пользователь.АутентификацияОС
									Или Пользователь.АутентификацияOpenID;
		Если Не ПользователюРазрешенВход Тогда
			Картинка = КартинкаПользовательБезНеобходимыхСвойств;
		ИначеЕсли Пользователь.ПарольУстановлен Тогда
			Картинка = КартинкаПользовательСАутентификацией;
		Иначе
			Картинка = КартинкаПользователь;
		КонецЕсли; 
		
		СписокВыбора.Добавить(Пользователь.Имя, Пользователь.ПолноеИмя, , Картинка);
		
	КонецЦикла; 	
	
	СписокВыбора.СортироватьПоПредставлению();

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПользовательСуществует(ИмяПользователя)

	Возврат ПользователиИнформационнойБазы.НайтиПоИмени(ИмяПользователя) <> Неопределено;

КонецФункции // ПользовательСуществует()

&НаКлиентеНаСервереБезКонтекста
Функция НовыйСвойстваПользователя()
	
	СвойстваПользователя = Новый Структура;
	СвойстваПользователя.Вставить("Имя");
	СвойстваПользователя.Вставить("УникальныйИдентификатор");
	СвойстваПользователя.Вставить("СохраняемоеЗначениеПароля");	// Содержит исходный пароль. Не обновлять при подмене пароля!
	СвойстваПользователя.Вставить("АутентификацияСтандартная");
	СвойстваПользователя.Вставить("АутентификацияОС");
	СвойстваПользователя.Вставить("АутентификацияOpenID");
	СвойстваПользователя.Вставить("ПарольУстановлен");
	СвойстваПользователя.Вставить("РежимЗапуска");
	
	СвойстваПользователя.Вставить("ПредупреждатьОбОпасныхДействиях");

	СвойстваПользователя.Вставить("НаличиеОсновныхРолей", Новый Соответствие);	// {Имя роли - Строка; Наличие роли - Булево}
	
	Возврат СвойстваПользователя;
	
КонецФункции // НовыйСвойстваПользователя()
 
&НаСервереБезКонтекста
Функция СвойстваПользователя(ИмяПользователя)

	СвойстваПользователя = НовыйСвойстваПользователя();
	
	Пользователь = ПользователиИнформационнойБазы.НайтиПоИмени(ИмяПользователя);
	Если Пользователь = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	ЗаполнитьЗначенияСвойств(СвойстваПользователя, Пользователь);
	
	СвойстваПользователя.ПредупреждатьОбОпасныхДействиях = Пользователь.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях;
	
	Для каждого Роль Из Метаданные.ОсновныеРоли Цикл
		СвойстваПользователя.НаличиеОсновныхРолей[Роль.Имя] = Пользователь.Роли.Содержит(Роль);
	КонецЦикла; 

	Возврат СвойстваПользователя;
	
КонецФункции // СвойстваПользователя()

&НаКлиентеНаСервереБезКонтекста
Функция СводкаПоСвойствамПользователя(СвойстваПользователя)

	Состав = Новый Массив;
	
	Состав.Добавить(СтрокаСводкиПользователя("Имя", 							 СвойстваПользователя.Имя));
	Состав.Добавить(СтрокаСводкиПользователя("Аутентификация 1С:Предприятия", 	 СвойстваПользователя.АутентификацияОС));
	Состав.Добавить(СтрокаСводкиПользователя("Пароль", 							 ?(СвойстваПользователя.ПарольУстановлен, "установлен", "пустой")));
	Состав.Добавить(СтрокаСводкиПользователя("Аутентификация средствами ОС", 	 СвойстваПользователя.АутентификацияОС));
	Состав.Добавить(СтрокаСводкиПользователя("Аутентификация OpenID", 			 СвойстваПользователя.АутентификацияOpenID));
	Состав.Добавить(СтрокаСводкиПользователя("Защита от опасных действий", 		 СвойстваПользователя.ПредупреждатьОбОпасныхДействиях));
	Состав.Добавить(СтрокаСводкиПользователя("Режим запуска", 					 СвойстваПользователя.РежимЗапуска));
	
	// Переносы строк
	МаксИндекс = Состав.ВГраница();
	Для ДопИндекс = - МаксИндекс По -1 Цикл
		Индекс = - ДопИндекс;
		Состав.Вставить(Индекс, Символы.ПС);
	КонецЦикла;
	
	Сводка = Новый ФорматированнаяСтрока(Состав);
	
	Возврат Сводка;

КонецФункции // СводкаПоСвойствамПользователя()

&НаКлиентеНаСервереБезКонтекста
Функция СтрокаСводкиПользователя(Свойство, Значение = "")

	ЦветЗначения = WebЦвета.СинийСоСтальнымОттенком; 
	Возврат Новый ФорматированнаяСтрока(Свойство, ": ", Новый ФорматированнаяСтрока(Строка(Значение), , ЦветЗначения));

КонецФункции // СтрокаСводкиПользователя()

&НаСервере
Процедура ПрочитатьСвойстваПользователя(ИмяПользователя)

	СвойстваПользователя = СвойстваПользователя(ИмяПользователя);	
	
	СохраняемоеЗначениеПароляОриг = СвойстваПользователя.СохраняемоеЗначениеПароля;
	
	Элементы.ИмяПользователя.РасширеннаяПодсказка.Заголовок = СводкаПоСвойствамПользователя(СвойстваПользователя);

КонецПроцедуры

&НаСервере
Процедура ПодменитьСвойстваПользователя()

	Если СвойстваПользователя = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Пользователь = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(
		СвойстваПользователя.УникальныйИдентификатор);
		
	Пользователь.Пароль						 = ПарольВременный;
	Пользователь.АутентификацияСтандартная	 = Истина;

	Если ВидПредупрежденийОбОпасныхДействиях = -1 Тогда
		Пользователь.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях = Ложь;
	ИначеЕсли ВидПредупрежденийОбОпасныхДействиях = 1 Тогда
		Пользователь.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях = Истина;
	Иначе
		Пользователь.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях = СвойстваПользователя.ПредупреждатьОбОпасныхДействиях;
	КонецЕсли; 
	
	Если ПредоставитьОсновныеРоли Тогда
	
		Для каждого Роль Из Метаданные.ОсновныеРоли Цикл
			Если Не СвойстваПользователя.НаличиеОсновныхРолей[Роль.Имя] Тогда
				Пользователь.Роли.Добавить(Роль);			
			КонецЕсли; 
		КонецЦикла; 
	
	КонецЕсли;
	
	Пользователь.Записать();
	
КонецПроцедуры // ПодменитьСвойстваПользователя()

&НаСервере
Процедура ВосстановитьСвойстваПользователя()
	
	Если СвойстваПользователя = Неопределено Тогда
		Возврат;
	КонецЕсли; 

	Пользователь = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(
		СвойстваПользователя.УникальныйИдентификатор);
		
	Пользователь.СохраняемоеЗначениеПароля = СвойстваПользователя.СохраняемоеЗначениеПароля;
	Пользователь.АутентификацияСтандартная = СвойстваПользователя.АутентификацияСтандартная;
	
	Пользователь.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях = СвойстваПользователя.ПредупреждатьОбОпасныхДействиях;
	
	Для каждого Роль Из Метаданные.ОсновныеРоли Цикл
		Если Не СвойстваПользователя.НаличиеОсновныхРолей[Роль.Имя] Тогда
			Пользователь.Роли.Удалить(Роль);
		КонецЕсли; 
	КонецЦикла; 

	Пользователь.Записать();
	
КонецПроцедуры

// Возвращает сохраняемое значение пароля по имени пользователя
//
// Параметры:
//  Пользователь	 - Строка							 - ПользовательИнформационнойБазы.Имя
//					 - УникальныйИдентификатор			 - ПользовательИнформационнойБазы.УникальныйИдентификатор
//					 - ПользовательИнформационнойБазы	 - Собственно, пользователь
// 
// Возвращаемое значение:
//  Строка - ПользовательИнформационнойБазы.СохраняемоеЗначениеПароля; 
//			Если пользователь не найден - Неопределено.
//
&НаСервереБезКонтекста 
Функция СохраняемоеЗначениеПароляПользователя(Пользователь)

	Если ТипЗнч(Пользователь) = Тип("Строка") Тогда
		ПользовательИнформационнойБазы = ПользователиИнформационнойБазы.НайтиПоИмени(Пользователь);
	ИначеЕсли ТипЗнч(Пользователь) = Тип("УникальныйИдентификатор") Тогда
		ПользовательИнформационнойБазы = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Пользователь);
	ИначеЕсли ТипЗнч(Пользователь) = Тип("ПользовательИнформационнойБазы") Тогда
		ПользовательИнформационнойБазы = Пользователь;
	Иначе
		ВызватьИсключение "Параметр Пользователь: Неверный тип";
	КонецЕсли; 
	Если ПользовательИнформационнойБазы = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	Возврат ПользовательИнформационнойБазы.СохраняемоеЗначениеПароля;

КонецФункции // СохраняемоеЗначениеПароляПользователя()

// Генерирует сохраняемое значение пароля,
// пригодное для помещение в ПользовательИнформационнойБазы.СохраняемоеЗначениеПароля
//
// Параметры:
//  Пароль	 - Строка	 - Пароль для создания сохраняемого значения
// 
// Возвращаемое значение:
//  Строка - Сохраняемое значение пароля
//
&НаСервереБезКонтекста 
Функция СоздатьСохраняемоеЗначениеПароля(Пароль)
	
	Если Не ЗначениеЗаполнено(Пароль) Тогда
		Возврат "";
	КонецЕсли; 
	
	СоставСохраняемогоЗначение = Новый Массив;
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.SHA1);
	ХешированиеДанных.Добавить(Пароль);
	СоставСохраняемогоЗначение.Добавить(Base64Строка(ХешированиеДанных.ХешСумма));
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.SHA1);
	ХешированиеДанных.Добавить(ВРег(Пароль));
	СоставСохраняемогоЗначение.Добавить(Base64Строка(ХешированиеДанных.ХешСумма));
	
	СохраняемоеЗначениеПароля = СтрСоединить(СоставСохраняемогоЗначение, ",");
	
	Возврат СохраняемоеЗначениеПароля;
	
КонецФункции

&НаКлиенте
Процедура ПодменитьПарольНаКлиенте()
	
	Если не ПроверитьНаличиеПользователяИнтерактивно() Тогда
		Возврат;
	КонецЕсли; 
	
	ПодменитьСвойстваПользователя();

	ПоказатьОповещениеПользователя(
		"Пароль подменён",
		,
		СтрШаблон("Пользователь: %1", ИмяПользователя));
		
	ПодключитьОбработчикОжидания("ВосстановитьПарольНаКлиенте", ТаймаутПодменыПароля, Истина);

КонецПроцедуры // ПодменитьПарольНаКлиенте()
	
&НаКлиенте
Процедура ВосстановитьПарольНаКлиенте()

	Если не ПроверитьНаличиеПользователяИнтерактивно() Тогда
		Возврат;
	КонецЕсли; 
	
	Если СвойстваПользователя = Неопределено Тогда
		Возврат;	
	КонецЕсли; 
	
	ВосстановитьСвойстваПользователя();
	ПоказатьОповещениеПользователя(
		"Пароль восстановлен",
		,
		СтрШаблон("Пользователь: %1", ИмяПользователя));
		
	ОтключитьОбработчикОжидания("ВосстановитьПарольНаКлиенте");
	ЭтаФорма.Доступность = Истина;

КонецПроцедуры // ВосстановитьПарольНаКлиенте()

&НаКлиенте
Процедура ЗапуститьСистемуПодВременнымПаролем()

	СтрокаСоединения = СтрокаСоединенияИнформационнойБазы();
	
	ПараметрыКоманднойСтроки = Новый Массив;
	
	// Пользователь и пароль
	ПараметрыКоманднойСтроки.Добавить(СтрШаблон("/N%1", ПараметрКоманднойСтрокиИзЗначения(ИмяПользователя)));
	ПараметрыКоманднойСтроки.Добавить(СтрШаблон("/P%1", ПараметрКоманднойСтрокиИзЗначения(ПарольВременный)));
	
	// Код доступа
	Если ЗначениеЗаполнено(КодДоступа) Тогда
		ПараметрыКоманднойСтроки.Добавить(СтрШаблон("/UC%1", ПараметрКоманднойСтрокиИзЗначения(КодДоступа)));
	КонецЕсли; 
	
	// Режим технического специалиста
	Если РежимТехническогоСпециалиста Тогда
		ПараметрыКоманднойСтроки.Добавить("/TechnicalSpecialistMode");
	КонецЕсли; 
	
	// Режим запуска
	Если ВидРежимаЗапуска = "Авто" Тогда
		ПараметрыКоманднойСтроки.Добавить("/AppAutoCheckMode");
	ИначеЕсли ВидРежимаЗапуска = "ОбычноеПриложение" Тогда
		ПараметрыКоманднойСтроки.Добавить("/RunModeOrdinaryApplication");
	ИначеЕсли ВидРежимаЗапуска = "УправляемоеПриложение" Тогда
		ПараметрыКоманднойСтроки.Добавить("/RunModeManagedApplication");
	Иначе
		// ничего
	КонецЕсли; 
	
	// ДопПараметрыКоманднойСтроки
	Если Не ПустаяСтрока(ДопПараметрыКоманднойСтроки) Тогда
		ПараметрыКоманднойСтроки.Добавить(ДопПараметрыКоманднойСтроки);
	КонецЕсли; 
	
	ПараметрыКоманднойСтроки = СтрСоединить(ПараметрыКоманднойСтроки, " ");
	
	ЗапуститьСистему(ПараметрыКоманднойСтроки, Ложь);

КонецПроцедуры // ЗапуститьПриложениеПодВременнымПаролем()

// Преобразует значение в допустимы параметр комендной строки
// Заменяет в тексте параметра кавычки и слэши
// При необходимости, заключает в кавычки
//
// Параметры:
//  Значение	 - Строка, Произвольный	 - Значение
//
&НаКлиентеНаСервереБезКонтекста
Функция ПараметрКоманднойСтрокиИзЗначения(Значение)
	
	ТекстПараметра = Строка(Значение);
	
	ТекстПараметра = СтрЗаменить(ТекстПараметра, "\", "\\");
	ТекстПараметра = СтрЗаменить(ТекстПараметра, """", "\""");
	
	Если СтрНайти(ТекстПараметра, " ") Или ПустаяСтрока(ТекстПараметра) Тогда
		ТекстПараметра = """" + ТекстПараметра + """";	
	КонецЕсли; 
	
	Возврат ТекстПараметра;

КонецФункции // ПараметрКоманднойСтрокиИзЗначения()

#КонецОбласти // СлужебныеПроцедурыИФункции
