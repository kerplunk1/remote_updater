import os
import time
import manage


def navigate():
    while True:
        print("REMOTE UPDATER")
        print("--------------\n")
        print("1. Отправить уведомление")
        print("2. Обновить Revit 2022")
        print("3. Активировать MS Office")
        print("4. Установить плагин BCF Manager")
        print("5. Установить плагин ModPlus")
        print("6. Установить MS Office")
        print("0. Выход")
        print("-------------------------\n")
        section = int(input("Выберите номер нужного пункта: "))

        os.system('cls')

        if section == 1:
            print("Отправка уведомления")
            print("--------------------\n")
            remote_host = input("Введите имя удаленного компьютера: ")
            message = input("Введите текст сообщения: ")
            manage.send_message(remote_host, message)
            
            time.sleep(3)
            os.system('cls')
        
        elif section == 2:
            print("Обновление Revit 22")
            print("-------------------\n")
            remote_host = input("Введите имя удаленного компьютера: ")
            manage.update_revit(remote_host)
            
            time.sleep(10)
            os.system('cls')
        
        elif section == 3:
            print("Активация MS Office")
            print("-------------------\n")
            remote_host = input("Введите имя удаленного компьютера: ")
            manage.activate_office(remote_host)
            
            time.sleep(3)
            os.system('cls')

        elif section == 4:
            print("Установка плагина BCF Manager")
            print("-------------------\n")
            remote_host = input("Введите имя удаленного компьютера: ")
            manage.bcf_install(remote_host)

            time.sleep(3)
            os.system('cls')

        elif section == 5:
            print("Установка плагина ModPlus")
            print("-------------------\n")
            remote_host = input("Введите имя удаленного компьютера: ")
            manage.modplus_install(remote_host)

            os.system('cls')

        elif section == 6:
            print("Установка MS Office")
            print("-------------------\n")
            remote_host = input("Введите имя удаленного компьютера: ")
            manage.office_install(remote_host)

            time.sleep(3)
            os.system('cls')

        else:
            print("Выход")
            
            time.sleep(0.5)
            os.system('cls')
            exit()


if __name__ == "__main__":
    navigate()

