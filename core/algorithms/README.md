# 🚀 Algoritmos Puros / Algorithms Pure — Scheme

Implementaciones de la [Fase 1 — Algoritmos Puros](https://yorche3.github.io/programming_languages/ROADMAP/#fase-1--algoritmos-puros--algorithms-pure-) en **Scheme**: ordenamientos elementales, estructuras de datos propias, ordenamientos óptimos y distribuidos, y búsqueda.

Los módulos de esta fase trabajan de forma **funcional**: reciben una lista de enteros y devuelven una lista nueva ordenada (las listas de Scheme son inmutables). El caso nulo se representa con `#f` como indicador de fallo (no se lanzan excepciones), porque `'()` es la única lista vacía y no se distingue de `null`.

---

## 📂 Módulos / Modules

| Módulo | Especificación | Enfoque | Tests | Estado |
|--------|---------------|---------|:-----:|:------:|
| [`naive_sort/`](naive_sort/) | [05_Naive_Sort](https://yorche3.github.io/programming_languages/core/algorithms/05_Naive_Sort/) | `guile` (SRFI-64) y `mit-scheme` + `scmunit` | 24 | ✅ |

---

## 📁 Estructura / Structure

```text
algorithms/
└── naive_sort/                        # 05_Naive_Sort
    ├── .gitignore                     # *.log
    ├── src/
    │   └── naive_sort.scm             # 3 funciones + helper remove-first
    ├── test/
    │   ├── naive_sort_tests_guile.scm # GNU Guile + SRFI-64
    │   └── naive_sort_tests.scm       # MIT/GNU Scheme + scmunit
    └── README.md
```

---

## 🛠️ Patrón común / Common Pattern

| Característica | Descripción |
|---------------|-------------|
| **Runtime** | GNU Guile 3.0.9 y MIT/GNU Scheme 12.1 (los dos runtimes del repositorio) |
| **CLI** | `guile --no-auto-compile -s <suite>_guile.scm` y `SCMUNIT_PATH=… mit-scheme --quiet --load <suite>.scm`, desde `test/` |
| **Andamiaje** | ✍️ Estructura manual (`mkdir -p src test`), la que ya usan [`foundations/numbers/`](../foundations/numbers/) y `foundations/unit_test/calculator/` |
| **Framework de tests** | `scmunit` para MIT/GNU Scheme y SRFI-64 para Guile, uno por suite |
| **Runner** | Cada runtime ejecuta su suite con `--load` / `-s`; no hay `run_tests.scm` |
| **Separación** | `src/` (módulo) ↔ `test/` (una suite por runtime) |
| **Módulo fuente** | Un único `src/<modulo>.scm` con funciones `define`, como `numbers.scm` |
| **API** | Una función por algoritmo: `(selection-sort arr)`, `(bubble-sort arr)`, `(insertion-sort arr)` |
| **Naming** | `kebab-case` en la API (convención de Scheme); los nombres `snake_case` de la especificación se conservan en los casos y en el mensaje del contrato |
| **Inmutabilidad** | Las listas son inmutables: los algoritmos construyen una lista nueva y las pruebas no necesitan copias |
| **Nulabilidad** | `#f` como indicador de fallo; la lista vacía es `'()` |
| **Mensajes de aserción** | Nombre del caso o del `testcase` con el formato `"{algorithm} should sort {caso}"` (scmunit no admite mensajes por aserción) |
| **Verificación estática** | No hay compilador previo: la comprobación es la carga del módulo por las suites. Guile avisa `possibly unbound variable` al autocompilar suites con `(load "../src/…")`; se evita con `--no-auto-compile` |
| **Artefactos** | `*.log` (registros que escriben las suites) — ignorados por el `.gitignore` del módulo |
| **Particularidades** | `remove` es de SRFI-1 y no está en el entorno base → helper propio `remove-first`; `(cdr '())` es un error, así que la guarda `n <= 1` debe ser explícita; los `let` con nombre sustituyen a los bucles imperativos |

---

## 🚀 Compilación rápida / Quick Build

```bash
# Naive Sort Tests
cd naive_sort/test
guile --no-auto-compile -s naive_sort_tests_guile.scm
SCMUNIT_PATH="$HOME/.local/share/scmunit/scmunit.scm" mit-scheme --quiet --load naive_sort_tests.scm
```

---

## ▶️ Siguiente / Next

👉 Continúa con los módulos pendientes de esta fase en el [Roadmap](https://yorche3.github.io/programming_languages/ROADMAP/).

👉 Continue with the pending modules of this phase in the [Roadmap](https://yorche3.github.io/programming_languages/ROADMAP/).

---

*[← Volver a Core](../README.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
