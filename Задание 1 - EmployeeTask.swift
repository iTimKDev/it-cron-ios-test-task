// Пункт 1 тестового задания — разбор исходного кода и предложенные улучшения.
//
// При выполнении исходного кода напечатается «Алексей». На втором сотруднике
// программа аварийно завершится: функция использует принудительную распаковку
// name!, а у этого сотрудника name равно nil. Остальные имена не напечатаются.
//
// Исходная функция читает внешний массив employees. Лучше принимать массив
// параметром, чтобы функцию можно было использовать с другими сотрудниками.
//
// В цикле имя безопасно распаковывается через guard let. Если имени нет,
// выводится сообщение «Имя не задано», затем continue переходит к следующему
// сотруднику. Если имя есть, оно выводится на печать.
//
// GenderEmployee ограничивает значения пола случаями male (мужчина) и female
// (женщина), поэтому нельзя передать произвольную строку с ошибкой в написании.
// isActive имеет тип Bool: для активности достаточно true и false, отдельный
// тип здесь не нужен. name остаётся String?, поскольку в задании не сказано,
// что имя обязательно должно быть указано.

enum GenderEmployee {
    case male   // мужчина
    case female // женщина
}

struct Employee {
    let name: String?
    let age: Int
    let gender: GenderEmployee
    let salary: Int
    let isActive: Bool
}

func printEmployees(employees: [Employee]) {
    for employee in employees {
        guard let name = employee.name else {
            print("Имя не задано")
            continue
        }

        print(name)
    }
}

let employees = [
    Employee(name: "Алексей", age: 25, gender: .male, salary: 150000, isActive: true),
    Employee(name: nil, age: 30, gender: .female, salary: 180000, isActive: true),
    Employee(name: "Мария", age: 22, gender: .female, salary: 90000, isActive: false),
    Employee(name: "Иван", age: 28, gender: .male, salary: 170000, isActive: true),
    Employee(name: "Екатерина", age: 35, gender: .female, salary: 210000, isActive: false)
]

printEmployees(employees: employees)
