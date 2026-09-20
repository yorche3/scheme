# Naive Sort — Scheme

Implementación de la especificación [05_Naive_Sort](https://yorche3.github.io/programming_languages/core/algorithms/05_Naive_Sort/) en **Scheme**, con suites de pruebas para los dos runtimes del repositorio: **MIT/GNU Scheme** con `scmunit` y **GNU Guile** con SRFI-64.

Los tres algoritmos elementales de ordenamiento $O(n^2)$ — **selection sort**, **bubble sort** e **insertion sort** — reciben una lista de enteros y devuelven una lista nueva ordenada, sin usar `sort` ni ninguna otra ayuda de ordenamiento de la biblioteca estándar.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`src/naive_sort.scm`](src/naive_sort.scm) | Único archivo con las 3 funciones del contrato y el helper `remove-first`. |
| [`test/naive_sort_tests_guile.scm`](test/naive_sort_tests_guile.scm) | Suite GNU Guile + SRFI-64: 3 grupos (uno por algoritmo) con los 8 casos. |
| [`test/naive_sort_tests.scm`](test/naive_sort_tests.scm) | Suite MIT/GNU Scheme + `scmunit`: mismo contrato, un `testcase` por algoritmo. |
| [`.gitignore`](.gitignore) | Ignora los registros de las suites (`*.log`). |

**Estructura de directorios esperada / Expected directory structure:**

```text
naive_sort/
├── .gitignore
├── src/
│   └── naive_sort.scm              # 3 algoritmos (naming kebab-case)
├── test/
│   ├── naive_sort_tests_guile.scm  # GNU Guile + SRFI-64
│   └── naive_sort_tests.scm        # MIT/GNU Scheme + scmunit
└── README.md
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** Estructura manual (`mkdir -p src test`), como indica la guía para Scheme, con el mismo patrón que `core/foundations/numbers/`: funciones sueltas en `src/` y dos suites en `test/`, una por runtime. No hay manifiesto ni compilación a un artefacto previo, y no se deja ningún `main` de ejemplo.

**EN:** Manual structure (`mkdir -p src test`), as the guide states for Scheme, following the same pattern as `core/foundations/numbers/`: standalone functions in `src/` and two suites in `test/`, one per runtime. There is no manifest or prior compilation artefact, and no example `main` is left behind.

### Inicialización / Initialization

```bash
mkdir -p scheme/core/algorithms/naive_sort/{src,test}
# Escribir src/naive_sort.scm y las dos suites de test/
# Requisito: scmunit instalado (SCMUNIT_PATH) para la suite de MIT/GNU Scheme
```

---

## 📄 Contrato e implementación / Contract & Implementation

**ES:** Las tres funciones reciben una lista de enteros y devuelven una lista nueva ordenada de menor a mayor. Las listas de Scheme son inmutables, así que el resultado vuelve por el valor devuelto (variante que la especificación permite). Si la entrada no es una lista se devuelve `#f` como indicador de fallo; si está vacía (`'()`) o tiene un solo elemento se devuelve sin cambios. No se lanza ninguna excepción.

**EN:** All three functions take a list of integers and return a new list sorted in ascending order. Scheme lists are immutable, so the result comes back through the return value (a variant the specification allows). A non-list input returns `#f` as the failure indicator; an empty list (`'()`) or a single-element list is returned unchanged. No exception is thrown.

```scheme
(define (selection-sort arr)
  (if (not (list? arr))
      #f
      (let loop ((unsorted arr)
                 (sorted '()))
        (if (null? unsorted)
            (reverse sorted)
            (let* ((min (apply min unsorted))
                   (rest (remove-first min unsorted)))
              (loop rest (cons min sorted)))))))
```

| Elemento del contrato | Representación en Scheme |
| --------------------- | ------------------------ |
| Lista de enteros | `'(5 2 9 1 5 6)` |
| Caso nulo / inválido | `#f` (indicador de fallo; `'()` es la única lista vacía y no se distingue de `null`) |
| Lista vacía | `'()` |
| Orden | funcional: se devuelve una lista nueva ordenada |
| Nombres de la especificación | `snake_case` conservado en los nombres de los casos y en el mensaje del contrato; la API usa `kebab-case`, la convención de Scheme: `selection-sort`, `bubble-sort`, `insertion-sort` |

---

## 🚀 Compilación y ejecución / Build & Run

### Requisitos / Requirements

- **GNU Guile** (en este entorno, 3.0.9) para la suite SRFI-64.
- **MIT/GNU Scheme** (12.1) y **scmunit** para la suite de `scmunit`; el framework se resuelve con `SCMUNIT_PATH`.

```bash
guile --version
mit-scheme --version
export SCMUNIT_PATH="$HOME/.local/share/scmunit/scmunit.scm"
```

### Ejecutar las pruebas / Run tests

**ES:** Ambas suites se ejecutan desde `test/`, porque las dos cargan el módulo con `(load "../src/naive_sort.scm")`.

**EN:** Both suites run from `test/`, because both load the module with `(load "../src/naive_sort.scm")`.

```bash
cd scheme/core/algorithms/naive_sort/test

# GNU Guile + SRFI-64
guile --no-auto-compile -s naive_sort_tests_guile.scm

# MIT/GNU Scheme + scmunit
SCMUNIT_PATH="$HOME/.local/share/scmunit/scmunit.scm" mit-scheme --quiet --load naive_sort_tests.scm
```

**Salida real / Actual output:**

```text
$ guile --no-auto-compile -s naive_sort_tests_guile.scm
%%%% Starting test naive_sort  (Writing full log to "naive_sort.log")
# of expected passes      24
```

```text
$ SCMUNIT_PATH="$HOME/.local/share/scmunit/scmunit.scm" mit-scheme --quiet --load naive_sort_tests.scm
# naive_sort 
  # selection_sort 
    # selection_sort should sort an unsorted array: . (0.ms) 
    # selection_sort should sort an already sorted array: . (0.ms) 
    … (24 líneas, una por caso) 
24 checks ran: 24 passed, 0 failed
```

> **ES:** 24 comprobaciones = 3 algoritmos × 8 casos. `--no-auto-compile` evita que Guile autocompile las suites al vuelo: el patrón `(load "../src/…")` hace que el compilador no vea las definiciones del módulo y avise con `warning: possibly unbound variable`, el mismo aviso que producen las suites de `numbers/` y `calculator/`. La salida de cada ejecución queda en `*.log` (ignorado).
> **EN:** 24 checks = 3 algorithms × 8 cases. `--no-auto-compile` stops Guile from auto-compiling the suites on the fly: the `(load "../src/…")` pattern means the compiler cannot see the module definitions and warns with `warning: possibly unbound variable`, the same warning produced by the `numbers/` and `calculator/` suites. Each run writes its output to `*.log` (ignored).

---

## 🧠 Algoritmos y operaciones / Algorithms & Operations

| Función / Algorithm | Enfoque / Approach | Descripción / Description |
| ------------------- | ------------------ | ------------------------- |
| `selection-sort(arr)` | funcional, con `apply min` | Extrae el mínimo del resto no ordenado con `apply min`, lo añade al acumulador y repite hasta vaciar la entrada; el acumulador se invierte al final. $O(n^2)$. |
| `bubble-sort(arr)` | funcional, con bandera | Cada pasada reconstruye la lista burbujeando el mayor al final y devuelve la bandera `swapped`; el bucle exterior termina cuando una pasada no intercambia nada (mejor caso $O(n)$). |
| `insertion-sort(arr)` | funcional, estable | Recorre la entrada insertando cada elemento en su lugar del acumulador ordenado con un `let` con nombre `insert`; la comparación estricta lo mantiene estable. $O(n^2)$ peor/promedio, $O(n)$ mejor. |

| Caso (descripción en la suite) | Entrada | Salida esperada |
| ------------------------------ | ------- | --------------- |
| an unsorted array | `'(5 2 9 1 5 6)` | `'(1 2 5 5 6 9)` |
| an already sorted array | `'(1 2 3 4 5)` | `'(1 2 3 4 5)` |
| a reverse ordered array | `'(5 4 3 2 1)` | `'(1 2 3 4 5)` |
| an array of identical elements | `'(7 7 7 7)` | `'(7 7 7 7)` |
| an array with negative numbers | `'(3 -1 4 -5 0)` | `'(-5 -1 0 3 4)` |
| a single element array | `'(42)` | `'(42)` |
| an empty array | `'()` | `'()` |
| a null input | `#f` | `#f` |

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** Divergencia idiomática aceptada: el orden es **funcional**, no *in-place* (las listas de Scheme son inmutables), así que cada función devuelve una lista nueva ordenada. Es la variante que la especificación permite con «in-place o retornando una copia ordenada», y hace innecesario copiar los fixtures en las pruebas.
- **EN:** Accepted idiomatic divergence: sorting is **functional**, not *in-place* (Scheme lists are immutable), so each function returns a new sorted list. This is the variant the specification allows with "in-place or returning a sorted copy", and it makes copying the fixtures in the tests unnecessary.
- **ES:** Divergencia de *naming* aceptada: la API usa `kebab-case` (`selection-sort`, `bubble-sort`, `insertion-sort`), la convención de Scheme; los nombres `snake_case` de la especificación se conservan en el nombre de cada caso y en el mensaje del contrato (`selection_sort should sort an unsorted array`), que es lo que reportan ambas suites.
- **EN:** Accepted naming divergence: the API uses `kebab-case` (`selection-sort`, `bubble-sort`, `insertion-sort`), Scheme's convention; the specification's `snake_case` names are kept in each case name and in the contract message (`selection_sort should sort an unsorted array`), which is what both suites report.
- **ES:** Caso nulo incluido: en Scheme `'()` no se distingue de la lista vacía, así que el indicador de fallo es `#f` (mismo criterio que Racket) y se comprueba como octavo caso, separado del array vacío. Ninguna función lanza excepciones.
- **EN:** Null case included: in Scheme `'()` cannot be distinguished from the empty list, so the failure indicator is `#f` (same criterion as Racket) and it is checked as the eighth case, separate from the empty array. No function throws exceptions.
- **ES:** `remove-first` es un helper propio del módulo: `remove` pertenece a SRFI-1 y **no** está en el entorno base de Guile ni de MIT/GNU Scheme, así que usarlo dejaba la biblioteca sin cargar (`Unbound variable: remove`).
- **EN:** `remove-first` is the module's own helper: `remove` belongs to SRFI-1 and is **not** in Guile's or MIT/GNU Scheme's base environment, so using it left it undefined (`Unbound variable: remove`).
- **ES:** La guarda `n <= 1` del pseudocódigo es explícita en `bubble-sort`: sin ella, la lista vacía llega a `(cdr unsorted)` y produce un error, porque `(cdr '())` no es válido.
- **EN:** The pseudocode's `n <= 1` guard is explicit in `bubble-sort`: without it, the empty list reaches `(cdr unsorted)` and raises an error, because `(cdr '())` is invalid.
- **ES:** `bubble-sort` conserva la bandera `swapped`: la pasada interior devuelve el par `(lista . bandera)` y el bucle exterior se detiene cuando no hubo intercambios, reproduciendo el `if not swapped: break` del pseudocódigo, con las comparaciones e intercambios hechos paso a paso.
- **EN:** `bubble-sort` keeps the `swapped` flag: the inner pass returns the `(list . flag)` pair and the outer loop stops when no swap happened, reproducing the pseudocode's `if not swapped: break`, with comparisons and swaps done step by step.
- **ES:** `insertion-sort` usa un `let` con nombre `insert` de dos parámetros (`x` y la lista pendiente) que devuelve la lista con el elemento insertado, y el acumulador se construye ya en orden ascendente (sin `reverse` final); la comparación `<` es estricta, así que el algoritmo es estable.
- **EN:** `insertion-sort` uses a named `let` `insert` with two parameters (`x` and the pending list) that returns the list with the element inserted, and the accumulator is built already in ascending order (no final `reverse`); the `<` comparison is strict, so the algorithm is stable.
- **ES:** Nota de desviación respecto a la ubicación esperada: se conserva `src/naive_sort.scm` (solo cambia la extensión) y se usan **dos** suites, `test/naive_sort_tests_guile.scm` y `test/naive_sort_tests.scm`, el patrón de `numbers/` y `calculator/` (una por runtime); no se añade `run_tests.scm` porque cada runtime ejecuta su suite directamente. Además, el *naming* de la API sigue la convención idiomática `kebab-case` descrita arriba.
- **EN:** Deviation note from the expected location: `src/naive_sort.scm` is kept (only the extension changes) and **two** suites are used, `test/naive_sort_tests_guile.scm` and `test/naive_sort_tests.scm`, the pattern from `numbers/` and `calculator/` (one per runtime); no `run_tests.scm` is added because each runtime runs its suite directly. Additionally, the API naming follows the idiomatic `kebab-case` convention described above.

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*[← Volver a Algoritmos Puros](../README.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
