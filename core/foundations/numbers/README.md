# Numbers — Scheme

Implementación de la especificación [04_Numbers](https://yorche3.github.io/programming_languages/core/foundations/04_Numbers/) en **Scheme**, con un módulo común y suites de pruebas separadas para MIT/GNU Scheme y GNU Guile.

La implementación cubre los tres enfoques requeridos: recursión directa (`_rec`), recursión con acumulador (`_acc`) e iteración (`_ite`).

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`src/numbers.scm`](src/numbers.scm) | Implementación de los 15 procedimientos: 5 algoritmos en 3 enfoques. |
| [`test/recursive_tests.scm`](test/recursive_tests.scm) | Suite MIT/GNU Scheme para las funciones `_rec`. |
| [`test/recursive_with_acc_tests.scm`](test/recursive_with_acc_tests.scm) | Suite MIT/GNU Scheme para las funciones `_acc`. |
| [`test/iterative_tests.scm`](test/iterative_tests.scm) | Suite MIT/GNU Scheme para las funciones `_ite`. |
| [`test/recursive_tests_guile.scm`](test/recursive_tests_guile.scm) | Suite GNU Guile/SRFI-64 para las funciones `_rec`. |
| [`test/recursive_with_acc_tests_guile.scm`](test/recursive_with_acc_tests_guile.scm) | Suite GNU Guile/SRFI-64 para las funciones `_acc`. |
| [`test/iterative_tests_guile.scm`](test/iterative_tests_guile.scm) | Suite GNU Guile/SRFI-64 para las funciones `_ite`. |
| [`.gitignore`](.gitignore) | Ignora los logs generados por SRFI-64. |

```text
numbers/
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

## 🛠️ Enfoque y construcción / Approach & Build

El proyecto se creó manualmente, sin herramientas de scaffolding. El código de producción está en un único archivo y las suites se separan por enfoque y por runtime de pruebas.

The project was created manually, without scaffolding tools. Production code is kept in one file, while test suites are separated by approach and testing runtime.

Los cinco algoritmos son:

- `sum_of_first_n`: suma los primeros `n` números.
- `factorial`: calcula el factorial de `n`.
- `fibonacci`: calcula el término `n` de Fibonacci.
- `greatest_common_divisor`: calcula el máximo común divisor.
- `least_common_multiple`: calcula el mínimo común múltiplo.

Cada algoritmo tiene los sufijos siguientes:

| Enfoque | Sufijo | Implementación Scheme |
|---------|--------|-----------------------|
| Recursivo directo | `_rec` | Llamadas recursivas cercanas a la definición matemática. |
| Recursivo con acumulador | `_acc` | Recursión de cola con estado acumulado. |
| Iterativo | `_ite` | Constructo estándar `do`, sin una función recursiva escrita por el usuario. |

---

## 📄 Archivos de configuración clave / Key Configuration Files

No se necesita un archivo de build para este proyecto. Scheme carga el módulo y las suites directamente con `load`.

No build configuration file is required. Scheme loads the module and test suites directly with `load`.

### MIT/GNU Scheme y `scmunit`

Las suites MIT/GNU Scheme cargan la biblioteca compartida mediante `SCMUNIT_PATH`:

```scheme
(load (or (get-environment-variable "SCMUNIT_PATH") "scmunit.scm"))
```

La copia compartida utilizada en este entorno está fuera del repositorio:

```text
$HOME/.local/share/scmunit/scmunit.scm
```

### GNU Guile y SRFI-64

Las suites de Guile cargan SRFI-64 con:

```scheme
(use-modules (srfi srfi-64))
```

Las dos familias de suites ejercitan el mismo `src/numbers.scm`; solo cambia la biblioteca y la sintaxis del runner.

---

## 🚀 Compilación y ejecución / Build & Run

### Requisitos / Requirements

Versiones verificadas:

- MIT/GNU Scheme 12.1
- GNU Guile 3.0.9
- `scmunit` de `jotaen/scmunit`, instalado en `$HOME/.local/share/scmunit/scmunit.scm`
- SRFI-64 disponible en Guile

```bash
mit-scheme --version
guile --version
```

### Configurar la biblioteca compartida / Configure shared library

```bash
export SCMUNIT_PATH="$HOME/.local/share/scmunit/scmunit.scm"
```

La variable se configura una vez por sesión y se reutiliza en todos los proyectos Scheme que adopten esta convención.

### MIT/GNU Scheme con `scmunit`

Desde el directorio de tests:

```bash
cd scheme/core/foundations/numbers/test

SCMUNIT_PATH="$HOME/.local/share/scmunit/scmunit.scm" \
mit-scheme --quiet --load recursive_tests.scm

SCMUNIT_PATH="$HOME/.local/share/scmunit/scmunit.scm" \
mit-scheme --quiet --load recursive_with_acc_tests.scm

SCMUNIT_PATH="$HOME/.local/share/scmunit/scmunit.scm" \
mit-scheme --quiet --load iterative_tests.scm
```

### GNU Guile con SRFI-64

```bash
cd scheme/core/foundations/numbers/test
guile -s recursive_tests_guile.scm
guile -s recursive_with_acc_tests_guile.scm
guile -s iterative_tests_guile.scm
```

---

## 📤 Salida esperada / Expected output

La especificación define 33 casos en total: 11 por enfoque. El formato textual depende del framework, pero el resultado debe ser equivalente a:

```text
tests runned 33
passed 33
failed 0
```

### MIT/GNU Scheme + `scmunit`

Cada suite produce 11 comprobaciones aprobadas:

```text
11 checks ran: 11 passed, 0 failed
```

Ejemplo de una suite:

```text
# recursive
  # sum_of_first_n_rec: ..
  # factorial_rec: ..
  # fibonacci_rec: ...
  # greatest_common_divisor_rec: ..
  # least_common_multiple_rec: ..

11 checks ran: 11 passed, 0 failed
```

Las tres suites producen conjuntamente 33 comprobaciones aprobadas y ningún fallo.

### GNU Guile + SRFI-64

Cada suite produce:

```text
# of expected passes      11
```

Las tres suites producen conjuntamente:

```text
# of expected passes      33
```

SRFI-64 puede escribir un archivo `.log` por suite; esos archivos quedan ignorados por `.gitignore`.

---

## 🧠 Operaciones / Operations

| Función | `_rec` | `_acc` | `_ite` |
|---------|--------|--------|--------|
| `sum_of_first_n` | Recursión directa | Acumulador | `do` |
| `factorial` | Recursión directa | Acumulador | `do` |
| `fibonacci` | Dos llamadas recursivas | Dos acumuladores | `do` |
| `greatest_common_divisor` | Euclides recursivo | Euclides con acumulador | `do` |
| `least_common_multiple` | Usa MCD y aritmética | Usa MCD y aritmética | Usa MCD y aritmética |

Las suites agrupan los casos por método: un grupo para cada algoritmo y 11 aserciones por enfoque.

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** Scheme garantiza proper tail recursion como parte de su modelo del lenguaje; por eso `_acc` se prueba como enfoque real y no solo como puente didáctico.
- **EN:** Scheme guarantees proper tail recursion as part of its language model; therefore `_acc` is tested as a real approach rather than only as an educational bridge.
- **ES:** Scheme no usa necesariamente `for`/`while`; el constructo estándar `do` permite expresar el enfoque iterativo sin escribir una función recursiva en `_ite`.
- **EN:** Scheme does not necessarily use `for`/`while`; the standard `do` construct expresses the iterative approach without writing a recursive function in `_ite`.
- **ES:** `do` fue verificado en MIT/GNU Scheme y Guile con un bucle que calcula la suma `1 + 2 + 3`.
- **EN:** `do` was verified in MIT/GNU Scheme and Guile with a loop calculating `1 + 2 + 3`.
- **ES:** MIT/GNU Scheme y Guile comparten el módulo de producción, pero usan suites distintas porque `scmunit` y SRFI-64 no son intercambiables.
- **EN:** MIT/GNU Scheme and Guile share the production module but use separate suites because `scmunit` and SRFI-64 are not interchangeable.
- **ES:** Racket no se usa como equivalente de MIT/GNU Scheme o Guile en este módulo.
- **EN:** Racket is not used as an equivalent of MIT/GNU Scheme or Guile in this module.
- **ES:** La división por cero no forma parte de los casos especificados.
- **EN:** Division by zero is outside the specified test cases.

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
