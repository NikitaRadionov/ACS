#include <iostream>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>
#include <vector>
#include <queue>
#include <random>

using namespace std;


// Константы
const int MAX_VISITORS_IN_GALLERY = 50;   // Максимальное количество посетителей в галерее
const int MAX_VIEWERS_PER_PICTURE = 10;   // Максимальное количество людей у одной картины
const int NUM_PICTURES = 5;               // Количество картин
const int MAX_TOTAL_VISITORS = 300;       // Общее количество посетителей

// Семафоры для картин
sem_t picture_semaphores[NUM_PICTURES];

// Семафор для управления входом в галерею
sem_t gallery_door;

// Мьютекс для синхронизации вывода
pthread_mutex_t print_mutex;

// Очередь посетителей, ожидающих входа в галерею
queue<int> waiting_queue;

// Функция для имитации случайной задержки
void random_sleep() {
    usleep(100000 + rand() % 300000); // от 0.1 до 0.4 секунд
}

// Генератор случайных чисел для перехода между картинами
random_device rd;
mt19937 gen(rd());
uniform_int_distribution<> picture_dist(0, NUM_PICTURES - 1);

// Функция посетителя
void* visitor_routine(void* arg) {
    int visitor_id = *((int*)arg);

    // Вход в галерею
    sem_wait(&gallery_door);

    pthread_mutex_lock(&print_mutex);
    cout << "Visitor " << visitor_id << " entered the gallery." << endl;
    pthread_mutex_unlock(&print_mutex);

    // Осмотр картин
    for (int i = 0; i < NUM_PICTURES; i++) {
        int picture_id = picture_dist(gen);
        
        // Попытка подойти к картине
        sem_wait(&picture_semaphores[picture_id]);
        
        pthread_mutex_lock(&print_mutex);
        cout << "Visitor " << visitor_id << " is viewing picture " << picture_id + 1 << "." << endl;
        pthread_mutex_unlock(&print_mutex);

        // Задержка для осмотра картины
        random_sleep();

        // Уход от картины
        sem_post(&picture_semaphores[picture_id]);
    }

    // Выход из галереи
    pthread_mutex_lock(&print_mutex);
    cout << "Visitor " << visitor_id << " is leaving the gallery." << endl;
    pthread_mutex_unlock(&print_mutex);

    sem_post(&gallery_door);
    pthread_exit(nullptr);
}

int main(int argc, char* argv[]) {
    int total_visitors;

    // Получение количества посетителей из командной строки
    if (argc != 2) {
        cerr << "Usage: " << argv[0] << " <number of visitors>\n";
        return 1;
    }
    total_visitors = atoi(argv[1]);

    if (total_visitors <= 0 || total_visitors > MAX_TOTAL_VISITORS) {
        cerr << "Error: The number of visitors must be between 1 and " << MAX_TOTAL_VISITORS << ".\n";
        return 1;
    }

    // Инициализация семафоров для картин
    for (int i = 0; i < NUM_PICTURES; i++) {
        sem_init(&picture_semaphores[i], 0, MAX_VIEWERS_PER_PICTURE);
    }

    // Инициализация семафора для входа в галерею
    sem_init(&gallery_door, 0, MAX_VISITORS_IN_GALLERY);

    // Инициализация мьютекса
    pthread_mutex_init(&print_mutex, nullptr);

    // Создание потоков для посетителей
    vector<pthread_t> visitor_threads(total_visitors);
    vector<int> visitor_ids(total_visitors);

    for (int i = 0; i < total_visitors; i++) {
        visitor_ids[i] = i + 1;
        pthread_create(&visitor_threads[i], nullptr, visitor_routine, &visitor_ids[i]);
        random_sleep(); // Новые посетители прибывают постепенно
    }

    // Ожидание завершения всех потоков посетителей
    for (int i = 0; i < total_visitors; i++) {
        pthread_join(visitor_threads[i], nullptr);
    }

    // Освобождение ресурсов
    for (int i = 0; i < NUM_PICTURES; i++) {
        sem_destroy(&picture_semaphores[i]);
    }
    sem_destroy(&gallery_door);
    pthread_mutex_destroy(&print_mutex);

    cout << "The gallery is closed. All visitors have left the premises." << endl;
    return 0;
}
