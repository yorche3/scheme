# 🚀 Fundamentos / Foundations — Scheme

Implementación de los ejercicios de la sección [Fundamentos / Foundations](https://yorche3.github.io/programming_languages/core/foundations/) del repositorio principal en **Scheme**.

---

## 📖 Descripción / Description

**ES:** Esta sección explora Scheme mediante dos implementaciones del lenguaje: **MIT/GNU Scheme** como ruta principal y **GNU Guile** como runtime adicional. Cubre scripts básicos, entrada estándar, pruebas unitarias y algoritmos numéricos en tres enfoques progresivos.

**EN:** This section explores Scheme through two language implementations: **MIT/GNU Scheme** as the primary route and **GNU Guile** as an additional runtime. It covers basic scripts, standard input, unit testing, and numerical algorithms in three progressive approaches.

Racket no se utiliza como equivalente de MIT/GNU Scheme o Guile en esta sección; es una implementación y un entorno con objetivos propios.

Racket is not used as an equivalent of MIT/GNU Scheme or Guile in this section; it is a separate implementation and environment with its own purposes.

---

## 📁 Estructura / Structure

```text
scheme/
└── core/
    └── foundations/
        ├── README.md                   # Este archivo / This file
        ├── helloworld/                 # 01_Hello_World — Primer script
        │   ├── hello_world.scm
        │   └── README.md
        ├── hellouser/                  # 02_Hello_User — Entrada estándar
        │   ├── hello_user.scm
        │   └── README.md
        ├── unit_test/
        │   └── calculator/             # 03_Unit_Test_Calculator
        │       ├── src/
        │       │   └── calculator.scm
        │       ├── test/
        │       │   ├── calculator_test.scm
        │       │   └── calculator_test_guile.scm
        │       ├── .gitignore
        │       └── README.md
        └── numbers/                    # 04_Numbers — Algoritmos numéricos
            ├── src/
            │   └── numbers.scm
            ├── test/
            │   ├── recursive_tests.scm
            │   ├── recursive_with_acc_tests.scm
            │   ├── iterative_tests.scm
            │   ├── recursive_tests_guile.scm
            │   ├── recursive_with_acc_tests_guile.scm
            │   └── iterative_tests_guile.scm
            ├── .gitignore
            └── README.md
```

---

## 🔢 Progresión / Progression

| Especificación | Proyecto | Conceptos | Tests | Dependencias |
| -------------- | --------- | --------- | :---: | ------------ |
| [`01_Hello_World`](https://yorche3.github.io/programming_languages/core/foundations/01_Hello_World/) | [`helloworld/`](helloworld/) | `display`, `newline`, ejecución como script | — | Solo Scheme |
| [`02_Hello_User`](https://yorche3.github.io/programming_languages/core/foundations/02_Hello_User/) | [`hellouser/`](hellouser/) | `read-line`, `define`, `string-append`, entrada estándar | — | Solo Scheme; módulo Guile `ice-9 rdelim` |
| [`03_Unit_Test_Calculator`](https://yorche3.github.io/programming_languages/core/foundations/03_Unit_Test_Calculator/) | [`unit_test/calculator/`](unit_test/calculator/) | operaciones educativas, `scmunit`, SRFI-64 | 5 por runner | `scmunit` / SRFI-64 |
| [`04_Numbers`](https://yorche3.github.io/programming_languages/core/foundations/04_Numbers/) | [`numbers/`](numbers/) | recursión, TCO, acumuladores, `do` | 15 por runner (33 checks) | `scmunit` / SRFI-64 |

---

## 🛠️ Enfoque general / General Approach

**ES:** Los proyectos de esta sección siguen una progresión gradual:

1. **Hello World**: script independiente con `display`, `newline` y `exit`, ejecutable por MIT/GNU Scheme y Guile.
2. **Hello User**: script con entrada estándar. MIT/GNU Scheme proporciona `read-line`; Guile lo obtiene importando `(ice-9 rdelim)`. La diferencia se documenta como comportamiento del runtime.
3. **Calculator**: primer proyecto con pruebas unitarias. El código de producción es común a ambos runtimes, mientras las suites se adaptan a cada framework: `scmunit` para MIT/GNU Scheme y SRFI-64 para Guile.
4. **Numbers**: implementa los cinco algoritmos en tres enfoques. Scheme garantiza proper tail recursion y ofrece el constructo estándar `do`, por lo que se prueban `_rec`, `_acc` e `_ite`: 15 tests agrupados que contienen 33 comprobaciones.

**EN:** The projects in this section follow a gradual progression:

1. **Hello World**: standalone script using `display`, `newline`, and `exit`, runnable with MIT/GNU Scheme and Guile.
2. **Hello User**: standard-input script. MIT/GNU Scheme provides `read-line`; Guile obtains it by importing `(ice-9 rdelim)`. The difference is documented as runtime behavior.
3. **Calculator**: first unit-tested project. Production code is shared by both runtimes, while suites adapt to each framework: `scmunit` for MIT/GNU Scheme and SRFI-64 for Guile.
4. **Numbers**: implements five algorithms in three approaches. Scheme guarantees proper tail recursion and provides the standard `do` construct, so `_rec`, `_acc`, and `_ite` are tested: 15 grouped tests containing 33 assertions.

---

## 📦 Requisitos / Requirements

| Herramienta | Uso | Verificación |
| ----------- | --- | ------------ |
| [MIT/GNU Scheme](https://www.gnu.org/software/mit-scheme/) 12.1 | Runtime principal y ejecución de suites `scmunit` | `mit-scheme --version` |
| [GNU Guile](https://www.gnu.org/software/guile/) 3.0.9 | Runtime adicional y suites SRFI-64 | `guile --version` |
| `scmunit` | Testing para MIT/GNU Scheme | Variable `SCMUNIT_PATH` |
| SRFI-64 | Testing estándar disponible en Guile | `(use-modules (srfi srfi-64))` |

La copia compartida de `scmunit` usada en este entorno está fuera del repositorio:

```text
$HOME/.local/share/scmunit/scmunit.scm
```

Configurarla para la sesión actual:

```bash
export SCMUNIT_PATH="$HOME/.local/share/scmunit/scmunit.scm"
```

No se copia `scmunit.scm` en cada proyecto.

---

## 🚀 Ejecución rápida / Quick Start

### Hello World

```bash
cd scheme/core/foundations/helloworld
mit-scheme --quiet --load hello_world.scm
```

Con Guile:

```bash
guile -s hello_world.scm
```

### Hello User

MIT/GNU Scheme:

```bash
cd scheme/core/foundations/hellouser
printf 'Ada\n' | mit-scheme --quiet --load hello_user.scm
```

Guile:

```bash
printf 'Ada\n' | guile -c '(use-modules (ice-9 rdelim)) (load "hello_user.scm")'
```

### Calculator

MIT/GNU Scheme + `scmunit`:

```bash
cd scheme/core/foundations/unit_test/calculator/test
SCMUNIT_PATH="$HOME/.local/share/scmunit/scmunit.scm" \
mit-scheme --quiet --load calculator_test.scm
```

Guile + SRFI-64:

```bash
guile -s calculator_test_guile.scm
```

### Numbers

MIT/GNU Scheme + `scmunit`:

```bash
cd scheme/core/foundations/numbers/test
SCMUNIT_PATH="$HOME/.local/share/scmunit/scmunit.scm" \
mit-scheme --quiet --load recursive_tests.scm
SCMUNIT_PATH="$HOME/.local/share/scmunit/scmunit.scm" \
mit-scheme --quiet --load recursive_with_acc_tests.scm
SCMUNIT_PATH="$HOME/.local/share/scmunit/scmunit.scm" \
mit-scheme --quiet --load iterative_tests.scm
```

Guile + SRFI-64:

```bash
guile -s recursive_tests_guile.scm
guile -s recursive_with_acc_tests_guile.scm
guile -s iterative_tests_guile.scm
```

---

## 🧪 Convenciones de pruebas / Testing Conventions

**ES:** Las pruebas están separadas por runtime porque `scmunit` y SRFI-64 no son intercambiables. Dentro de cada enfoque, los casos se agrupan por método: cinco grupos de algoritmos contienen 11 comprobaciones por suite.

**EN:** Tests are separated by runtime because `scmunit` and SRFI-64 are not interchangeable. Within each approach, cases are grouped by method: five algorithm groups contain 11 assertions per suite.

Para `numbers`, cada runtime ejecuta tres suites:

- `recursive`: 11 comprobaciones
- `recursive_with_accumulator`: 11 comprobaciones
- `iterative`: 11 comprobaciones

Total por runtime: **33 comprobaciones, 0 fallos**.

---

## 🧹 Artefactos de ejecución / Runtime Artifacts

SRFI-64 genera logs durante las pruebas de `calculator` y `numbers`. Los `.gitignore` locales excluyen esos archivos para que no se versionen.

SRFI-64 generates logs while testing `calculator` and `numbers`. Local `.gitignore` files exclude those files so they are not versioned.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
