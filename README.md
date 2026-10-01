# Projekt w języku Ada

Projekt w języku Ada skonfigurowany pod **Alire** (`alr`).

## Struktura projektu

```text
├── alire.toml           # Konfiguracja pakietu / projektu Alire
├── ada_projekt.gpr      # Plik konfiguracyjny kompilatora GNAT
├── src/
│   ├── main.adb         # Główny punkt wejścia aplikacji
│   ├── greetings.ads    # Specyfikacja pakietu Greetings (nagłówek/interfejs)
│   └── greetings.adb    # Ciało pakietu Greetings (implementacja)
└── .gitignore
```

---

## 🚀 Kompilacja i uruchomienie

Wystarczy wpisać w głównym katalogu projektu:

```bash
alr run
```

Alire automatycznie skompiluje projekt i uruchomi plik wykonywalny.

Inne przydatne polecenia:
* `alr build` – tylko kompilacja
* `alr clean` – czyszczenie plików obiektowych

---

## 📊 Diagramy architektury i przepływu

### 1. Diagram zależności modułów (Architecture Flowchart)

```mermaid
flowchart TD
    subgraph Punkt_Wejscia ["Punkt Wejścia"]
        Main["src/main.adb<br/>(procedure Main)"]
    end

    subgraph Pakiet_Greetings ["Moduł Greetings"]
        G_ADS["src/greetings.ads<br/><i>(Specyfikacja / Interfejs)</i>"]
        G_ADB["src/greetings.adb<br/><i>(Ciało / Implementacja)</i>"]
    end

    subgraph Biblioteka_Standardowa ["Ada Standard Library"]
        TIO["Ada.Text_IO<br/>(Wejście / Wyjście)"]
    end

    Main -->|"with Greetings;"| G_ADS
    Main -->|"with Ada.Text_IO;"| TIO
    G_ADB -.->|"implementuje"| G_ADS
    G_ADB -->|"with Ada.Text_IO;"| TIO
```

### 2. Diagram sekwencji wywołań (Sequence Diagram)

```mermaid
sequenceDiagram
    autonumber
    actor User as Użytkownik (Terminal)
    participant Main as main.adb
    participant Greetings as greetings.adb
    participant TextIO as Ada.Text_IO

    User->>Main: Uruchomienie (alr run)
    Main->>TextIO: Put_Line("Witaj w projekcie Ada!...")
    TextIO-->>User: Wyświetlenie nagłówka w konsoli
    Main->>Greetings: Say_Hello(Name => "Programisto")
    activate Greetings
    Greetings->>Greetings: Format_Greeting("Programisto")
    Greetings->>TextIO: Put_Line("Czesc, Programisto!...")
    TextIO-->>User: Wyświetlenie powitania w konsoli
    deactivate Greetings
    Main-->>User: Zakończenie programu (Exit 0)
```
