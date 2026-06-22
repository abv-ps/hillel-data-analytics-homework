### 🛠️ Етап очищення та трансформації даних (Power Query / M)

Для підготовки даних до аналізу було проведено комплексне очищення, фільтрацію за датами (серпень 2025 року), розрахунок метрик активності користувачів та об'єднання довідників.

<details>
<summary>📝 Таблиця: country (Довідник країн)</summary>

```powerquery
let
    Источник = Excel.Workbook(File.Contents("D:\Downloads\ab_test_dataset_v5.xlsx"), null, true),
    country_Sheet = Источник{[Item="country",Kind="Sheet"]}[Data],
    #"Повышенные заголовки" = Table.PromoteHeaders(country_Sheet, [PromoteAllScalars=true]),
    #"Измененный тип" = Table.TransformColumnTypes(#"Повышенные заголовки",{{"country id", Int64.Type}, {"country code", type text}}),
    #"Удалены пустые строки" = Table.SelectRows(#"Измененный тип", each not List.IsEmpty(List.RemoveMatchingItems(Record.FieldValues(_), {"", null}))),
    #"Добавлен пользовательский объект" = Table.AddColumn(#"Удалены пустые строки", "ID type", each "Country"),
    #"Измененный тип1" = Table.TransformColumnTypes(#"Добавлен пользовательский объект",{{"ID type", type text}})
in
    #"Измененный тип1"
```
</details>

<details>
<summary>📝 Таблиця: device (Довідник пристроїв)</summary>

```powerquery
let
    Источник = Excel.Workbook(File.Contents("D:\Downloads\ab_test_dataset_v5.xlsx"), null, true),
    device_Sheet = Источник{[Item="device",Kind="Sheet"]}[Data],
    #"Повышенные заголовки" = Table.PromoteHeaders(device_Sheet, [PromoteAllScalars=true]),
    #"Измененный тип" = Table.TransformColumnTypes(#"Повышенные заголовки",{{"device_id", Int64.Type}, {"device_name", type text}}),
    #"Удалены пустые строки" = Table.SelectRows(#"Измененный тип", each not List.IsEmpty(List.RemoveMatchingItems(Record.FieldValues(_), {"", null}))),
    #"Добавлен пользовательский объект" = Table.AddColumn(#"Удалены пустые строки", "ID type", each "Device"),
    #"Измененный тип1" = Table.TransformColumnTypes(#"Добавлен пользовательский объект",{{"ID type", type text}})
in
    #"Измененный тип1"
```
</details>

<details>
<summary>📝 Таблиця: group (Словник тестових груп)</summary>

```powerquery
let
    Источник = Excel.Workbook(File.Contents("D:\Downloads\ab_test_dataset_v5.xlsx"), null, true),
    group_Sheet = Источник{[Item="group",Kind="Sheet"]}[Data],
    #"Повышенные заголовки" = Table.PromoteHeaders(group_Sheet, [PromoteAllScalars=true]),
    #"Измененный тип" = Table.TransformColumnTypes(#"Повышенные заголовки",{{"group_id", Int64.Type}, {"group_label", type text}}),
    #"Удалены пустые строки" = Table.SelectRows(#"Измененный тип", each not List.IsEmpty(List.RemoveMatchingItems(Record.FieldValues(_), {"", null})))
in
    #"Удалены пустые строки"
```
</details>

<details>
<summary>📝 Таблиця: user (Профілі користувачів та збагачення даних)</summary>

```powerquery
let
    Источник = Excel.Workbook(File.Contents("D:\Downloads\ab_test_dataset_v5.xlsx"), null, true),
    user_Sheet = Источник{[Item="user",Kind="Sheet"]}[Data],
    #"Повышенные заголовки" = Table.PromoteHeaders(user_Sheet, [PromoteAllScalars=true]),
    #"Измененный тип" = Table.TransformColumnTypes(#"Повышенные заголовки",{{"user_id", Int64.Type}, {"device_id", Int64.Type}, {"country_id", Int64.Type}, {"group_id", Int64.Type}, {"days_on_product", Int64.Type}}),
    #"Удалены пустые строки" = Table.SelectRows(#"Измененный тип", each ([user_id] <> null)),
    #"Объединенные запросы" = Table.NestedJoin(#"Удалены пустые строки", {"device_id"}, device, {"device_id"}, "device", JoinKind.LeftOuter),
    #"Развернутый элемент device" = Table.ExpandTableColumn(#"Объединенные запросы", "device", {"device_name"}, {"device_name"}),
    #"Удаленные столбцы" = Table.RemoveColumns(#"Развернутый элемент device",{"device_id"}),
    #"Объединенные запросы1" = Table.NestedJoin(#"Удаленные столбцы", {"country_id"}, country, {"country_id"}, "country", JoinKind.LeftOuter),
    #"Развернутый элемент country" = Table.ExpandTableColumn(#"Объединенные запросы1", "country", {"country_code"}, {"country_code"}),
    #"Удаленные столбцы1" = Table.RemoveColumns(#"Развернутый элемент country",{"country_id"})
in
    #"Удаленные столбцы1"
```
</details>

<details>
<summary>📝 Таблиця: ID_Dictionary (Об'єднання country та device через Append)</summary>

```powerquery
let
    Источник = Table.Combine({country, device})
in
    Источник
```
</details>

<details>
<summary>📝 Таблиця: min_date (Визначення дати першої активності)</summary>

```powerquery
let
    Источник = Excel.Workbook(File.Contents("D:\Downloads\ab_test_dataset_v5.xlsx"), null, true),
    daily_Sheet = Источник{[Item="daily",Kind="Sheet"]}[Data],
    #"Повышенные заголовки" = Table.PromoteHeaders(daily_Sheet, [PromoteAllScalars=true]),
    #"Измененный тип" = Table.TransformColumnTypes(#"Повышенные заголовки",{{"user_id", Int64.Type}, {"date", type date}, {"converted", Int64.Type}}),
    #"Вставлено: год" = Table.AddColumn(#"Измененный тип", "Year", each Date.Year([date]), Int64.Type),
    #"Вставлено: месяц" = Table.AddColumn(#"Вставлено: год", "Month", each Date.Month([date]), Int64.Type),
    #"Вставлено: день" = Table.AddColumn(#"Вставлено: месяц", "Day", each Date.Day([date]), Int64.Type),
    #"Сортированные строки" = Table.Sort(#"Вставлено: день",{{"Year", Order.Descending}, {"Month", Order.Descending}}),
    #"Строки с примененным фильтром" = Table.SelectRows(#"Сортированные строки", each ([Year] = 2025) and ([Month] = 8)),
    #"Сгруппированные строки" = Table.Group(#"Строки с примененным фильтром", {"user_id"}, {{"first_activity", each List.Min([date]), type nullable date}})
in
    #"Сгруппированные строки"
```
</details>

<details>
<summary>📝 Таблиця: activity_count (Розрахунок загальної кількості сесій)</summary>

```powerquery
let
    Источник = Excel.Workbook(File.Contents("D:\Downloads\ab_test_dataset_v5.xlsx"), null, true),
    daily_Sheet = Источник{[Item="daily",Kind="Sheet"]}[Data],
    #"Повышенные заголовки" = Table.PromoteHeaders(daily_Sheet, [PromoteAllScalars=true]),
    #"Измененный тип" = Table.TransformColumnTypes(#"Повышенные заголовки",{{"user_id", Int64.Type}, {"date", type date}, {"converted", Int64.Type}}),
    #"Вставлено: год" = Table.AddColumn(#"Измененный тип", "Year", each Date.Year([date]), Int64.Type),
    #"Вставлено: месяц" = Table.AddColumn(#"Вставлено: год", "Month", each Date.Month([date]), Int64.Type),
    #"Вставлено: день" = Table.AddColumn(#"Вставлено: месяц", "Day", each Date.Day([date]), Int64.Type),
    #"Сортированные строки" = Table.Sort(#"Вставлено: день",{{"Year", Order.Descending}, {"Month", Order.Descending}}),
    #"Строки с примененным фильтром" = Table.SelectRows(#"Сортированные строки", each ([Year] = 2025) and ([Month] = 8)),
    #"Сгруппированные строки" = Table.Group(#"Строки с примененным фильтром", {"user_id"}, {{"activity_cnt", each Table.RowCount(_), Int64.Type}})
in
    #"Сгруппированные строки"
```
</details>

<details>
<summary>📝 Таблиця: daily (Фінальна таблиця фактів активності)</summary>

```powerquery
let
    Источник = Excel.Workbook(File.Contents("D:\Downloads\ab_test_dataset_v5.xlsx"), null, true),
    daily_Sheet = Источник{[Item="daily",Kind="Sheet"]}[Data],
    #"Повышенные заголовки" = Table.PromoteHeaders(daily_Sheet, [PromoteAllScalars=true]),
    #"Измененный тип" = Table.TransformColumnTypes(#"Повышенные заголовки",{{"user_id", Int64.Type}, {"date", type date}, {"converted", Int64.Type}}),
    #"Вставлено: год" = Table.AddColumn(#"Измененный тип", "Year", each Date.Year([date]), Int64.Type),
    #"Вставлено: месяц" = Table.AddColumn(#"Вставлено: год", "Month", each Date.Month([date]), Int64.Type),
    #"Вставлено: день" = Table.AddColumn(#"Вставлено: месяц", "Day", each Date.Day([date]), Int64.Type),
    #"Сортированные строки" = Table.Sort(#"Вставлено: день",{{"Year", Order.Descending}, {"Month", Order.Descending}}),
    #"Строки с примененным фильтром" = Table.SelectRows(#"Сортированные строки", each ([Year] = 2025) and ([Month] = 8)),
    #"Объединенные запросы" = Table.NestedJoin(#"Строки с примененным фильтром", {"user_id"}, min_date, {"user_id"}, "min_date", JoinKind.LeftOuter),
    #"Развернутый элемент min_date" = Table.ExpandTableColumn(#"Объединенные запросы", "min_date", {"first_activity"}, {"first_activity"}),
    #"Добавлен пользовательский объект" = Table.AddColumn(#"Развернутый элемент min_date", "days_since_first_activity", each [date]-[first_activity]),
    #"Измененный тип1" = Table.TransformColumnTypes(#"Добавлен пользовательский объект",{{"days_since_first_activity", Int64.Type}}),
    #"Добавлен пользовательский объект3" = Table.AddColumn(#"Измененный тип1", "is_weekend", each Date.DayOfWeek([date], Day.Monday) >= 5),
    #"Измененный тип2" = Table.TransformColumnTypes(#"Добавлен пользовательский объект3",{{"is_weekend", type logical}}),
    #"Объединенные запросы1" = Table.NestedJoin(#"Измененный тип2", {"user_id"}, activity_count, {"user_id"}, "activity_count", JoinKind.LeftOuter),
    #"Развернутый элемент activity_count" = Table.ExpandTableColumn(#"Объединенные запросы1", "activity_count", {"activity_cnt"}, {"activity_cnt"}),
    #"Добавлен пользовательский объект1" = Table.AddColumn(#"Развернутый элемент activity_count", "activity_type", each if [activity_cnt] > 3 then "Active" else "Inactive")
in
    #"Добавлен пользовательский объект1"
```
</details>
