const String txtNothingFind = "Нет записей";
const String txtSearchResult = 'Результаты поиска';
const String txtOK = 'OK';
const String txtToBack = 'Назад';
const String txtStages = 'Этапы';
const String txtSearch = 'Поиск';
const String txtRoute = 'Маршрут';
const String txtClient = 'Клиент';
const String txtTaskCurrent = 'Текущие';
const String txtDocs = 'Документы';
const String txtDoc = 'Документ';
const String txtDetails = 'Детали';
const String txtTaskWait = 'Очередь';
const String txtTaskClosed = 'Закрыты';
const String txtTaskComplete = 'Выполнено';
const String txtStatus = 'Статус';
const String txtExit = 'Выход';
const String txtTasks = 'Задачи';
const String txtProfile = 'Профиль';
const String txtSettings = 'Настройки';
const String txtshowFailedLogin = 'Не верно введен телефон или пароль';
const String txtshowFailedOff = 'Пользователь отключен';
const String txtshowFailedUnknown = 'Неизвестная ошибка';
const String txtshowFailedDenied = 'Доступ запрещен';
const String txtshowFailedOkButton = 'Понятно';
const String txtSpecialDemandsNotSet = "Условия не указаны";
const String txtfreight_places = "Мест";
const String txtfreight_weight = "Вес";
const String txtDate = 'Дата';
const String txtChat = 'Чат';
const String txtLoading = "Загрузка";
const String txtErrorLoading = "Ошибка во время загрузки";
const String txtPassword = "Пароль";
const String txtObemPerevozki = "Объем перевозки";
const String txtNo = "нет";
const String delimeter = ": ";
const String txtNewchatmessage = "Новое сообщение чата";
const String txtNewmessage = "Новое событие";
const String txtLoadError = "Ошибка во время загрузки";
const String txtName = "Имя";
const String txtStartType = "Начните набирать ...";
const String txtWriteToChat = "Написать в чат";


class strMethod {
  static String statusStr(String status) {
    //print(status);
    switch (status) {
      case "1":
        return 'Задание принято';
      case "2":
        return 'Выехал';
      case "3":
        return 'На месте';
      case "4":
        return 'Начало разг. / погр.';
      case "5":
        return 'Заверш. разг. / погр.';
      default:
        return 'не известно';
    }
  }
}

