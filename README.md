# Scheme

Proyectos en **Scheme**, explorando principalmente **MIT/GNU Scheme** y **GNU Guile**. La sección incluye scripts independientes, entrada estándar y proyectos con pruebas unitarias adaptadas a cada runtime.

Racket no se utiliza como equivalente de MIT/GNU Scheme o Guile en este directorio; se documenta como una implementación separada en su propio proyecto.

---

## 📂 Módulos / Modules

| Módulo | Descripción |
| ------ | ----------- |
| [`core/`](core/) | Implementaciones de los módulos Core del roadmap. |
| [`core/foundations/`](core/foundations/) | **Fase 0 — Fundamentos**: `helloworld`, `hellouser`, `unit_test/calculator`, `numbers` |

---

## ▶️ Comenzar / Getting Started

### Hello World

```bash
cd core/foundations/helloworld
mit-scheme --quiet --load hello_world.scm
```

### Hello User

```bash
cd core/foundations/hellouser
printf 'Ada\n' | mit-scheme --quiet --load hello_user.scm
```

### Calculator tests

```bash
export SCMUNIT_PATH="$HOME/.local/share/scmunit/scmunit.scm"
cd core/foundations/unit_test/calculator/test
mit-scheme --quiet --load calculator_test.scm
```

### Numbers tests

```bash
cd core/foundations/numbers/test
SCMUNIT_PATH="$HOME/.local/share/scmunit/scmunit.scm" mit-scheme --quiet --load recursive_tests.scm
SCMUNIT_PATH="$HOME/.local/share/scmunit/scmunit.scm" mit-scheme --quiet --load recursive_with_acc_tests.scm
SCMUNIT_PATH="$HOME/.local/share/scmunit/scmunit.scm" mit-scheme --quiet --load iterative_tests.scm
```

Para ejecutar con Guile, usa las suites con sufijo `_guile` documentadas en [`core/foundations/`](core/foundations/).

---

## 📦 Requisitos / Requirements

| Herramienta | Uso | Verificación |
| ----------- | --- | ------------ |
| [MIT/GNU Scheme](https://www.gnu.org/software/mit-scheme/) 12.1 | Runtime principal | `mit-scheme --version` |
| [GNU Guile](https://www.gnu.org/software/guile/) 3.0.9 | Runtime adicional | `guile --version` |
| [`scmunit`](https://github.com/jotaen/scmunit) | Testing en MIT/GNU Scheme | `SCMUNIT_PATH` |
| SRFI-64 | Testing en Guile | `(use-modules (srfi srfi-64))` |

La copia compartida de `scmunit` utilizada en este entorno está fuera del repositorio:

```bash
export SCMUNIT_PATH="$HOME/.local/share/scmunit/scmunit.scm"
```

No se copia la biblioteca en cada proyecto.

---

## 🏗️ Tipos de proyecto / Project Types

### 1. Script independiente

**ES:** `helloworld` y `hellouser` son archivos `.scm` ejecutados directamente mediante MIT/GNU Scheme o Guile. No utilizan sistema de build ni dependencias externas de producción.

**EN:** `helloworld` and `hellouser` are `.scm` files run directly with MIT/GNU Scheme or Guile. They use no build system or external production dependencies.

### 2. Proyecto con pruebas unitarias

**ES:** `calculator` y `numbers` separan `src/` y `test/`. MIT/GNU Scheme usa `scmunit`; Guile usa SRFI-64. Las suites se mantienen separadas porque las APIs de testing no son intercambiables.

**EN:** `calculator` and `numbers` separate `src/` and `test/`. MIT/GNU Scheme uses `scmunit`; Guile uses SRFI-64. Suites remain separate because the testing APIs are not interchangeable.

---

## 🔁 TCO e iteración / TCO and Iteration

Scheme garantiza proper tail recursion. Además, el constructo estándar `do` permite expresar el enfoque iterativo sin depender de `for` o `while` al estilo imperativo.

Scheme guarantees proper tail recursion. Its standard `do` construct also expresses the iterative approach without depending on imperative-style `for` or `while` loops.

Por eso `numbers` implementa y prueba los tres enfoques: `_rec`, `_acc` e `_ite`, con 33 comprobaciones por runtime.

Therefore `numbers` implements and tests all three approaches: `_rec`, `_acc`, and `_ite`, with 33 assertions per runtime.

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*