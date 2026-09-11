# Calculator — Scheme

Implementación de la especificación [03_Unit_Test_Calculator](https://yorche3.github.io/programming_languages/core/foundations/03_Unit_Test_Calculator/) en **Scheme**, con un módulo común y dos rutas de pruebas según la implementación del lenguaje:

- **MIT/GNU Scheme**: `scmunit` en minúsculas, proyecto `jotaen/scmunit`.
- **GNU Guile**: SRFI-64, disponible mediante `(use-modules (srfi srfi-64))`.

Racket no se usa como equivalente de Scheme en este módulo. Tiene otro propósito y otra implementación, por lo que queda fuera de esta ruta de verificación.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`src/calculator.scm`](src/calculator.scm) | Implementación portable de las cinco operaciones. |
| [`test/calculator_test.scm`](test/calculator_test.scm) | Suite MIT/GNU Scheme con `scmunit`. |
| [`test/calculator_test_guile.scm`](test/calculator_test_guile.scm) | Suite GNU Guile con SRFI-64. |
| [`.gitignore`](.gitignore) | Ignora logs locales de ejecución. |

```text
calculator/
├── src/
│   └── calculator.scm
├── test/
│   ├── calculator_test.scm
│   └── calculator_test_guile.scm
├── .gitignore
└── README.md
```

---

## 🛠️ Enfoque y construcción / Approach & Build

El módulo contiene las operaciones exigidas por la especificación:

- `addition(a, b)`: suma directa.
- `subtraction(a, b)`: resta directa.
- `multiplication(a, b)`: suma repetitiva mediante un bucle recursivo.
- `division(a, b)`: resta repetitiva para contar el cociente entero.
- `modulus(a, b)`: reutiliza `division` y `multiplication` para calcular el resto.

La implementación de `src/calculator.scm` utiliza únicamente procedimientos comunes de Scheme. No incluye comentarios inline ni depende de funciones específicas de Racket, MIT/GNU Scheme o Guile, salvo el error de división por cero proporcionado por el entorno.

---

## 📄 Archivos de configuración clave / Key Configuration Files

No se requiere un archivo de build para este proyecto. El código se carga directamente desde `src/` y cada implementación Scheme usa su propia suite de pruebas en `test/`.

No build configuration file is required for this project. Source code is loaded directly from `src/`, and each Scheme implementation uses its own test suite under `test/`.

| Archivo | Propósito |
|---------|-----------|
| [`src/calculator.scm`](src/calculator.scm) | Módulo común con las cinco operaciones. |
| [`test/calculator_test.scm`](test/calculator_test.scm) | Runner MIT/GNU Scheme con `scmunit`. |
| [`test/calculator_test_guile.scm`](test/calculator_test_guile.scm) | Suite Guile con SRFI-64. |
| [`.gitignore`](.gitignore) | Ignora `calculator.log`, generado por la suite de Guile. |

La separación de suites evita mezclar las APIs de `scmunit` y SRFI-64, que no son intercambiables.

---

## 🚀 Ejecución / Run

### Requisitos comunes / Common requirements

```bash
scheme --version
mit-scheme --version
guile --version
```

Versiones verificadas:

- MIT/GNU Scheme 12.1
- GNU Guile 3.0.9

### MIT/GNU Scheme con scmunit

La dependencia `scmunit` no está instalada actualmente en este entorno. Por ese motivo, la suite MIT/GNU Scheme está preparada pero su ejecución queda pendiente de instalación manual.

Cuando `scmunit.scm` esté disponible en `test/` o en el `load path`:

```bash
cd scheme/core/foundations/unit_test/calculator/test
scheme --quiet --load calculator_test.scm
```

También puede usarse:

```bash
mit-scheme --quiet --load calculator_test.scm
```

La carga inicial esperada es:

```scheme
(load "scmunit.scm")
```

`scmunit` usa `assert`, `testcase`, `testcase*` y `scmunit-run*`. No forma parte de MIT/GNU Scheme ni del paquete Debian `scmutils`; debe instalarse manualmente.

### GNU Guile con SRFI-64

```bash
cd scheme/core/foundations/unit_test/calculator/test
guile -s calculator_test_guile.scm
```

> **ES:** La salida exacta depende del runner de SRFI-64, pero deben completarse 5 pruebas sin fallos.
> **EN:** The exact output depends on the SRFI-64 runner, but all 5 tests must complete without failures.

### Salida esperada / Expected output

La especificación define cinco operaciones y espera que las cinco pruebas pasen:

```text
Tests run: 5, Passed: 5, Failed: 0
```

El formato exacto cambia según la implementación de Scheme y la biblioteca de testing.

### GNU Guile + SRFI-64

La ejecución verificada en este entorno fue:

```text
%%%% Starting test calculator  (Writing full log to "calculator.log")
# of expected passes      5
```

El mensaje `# of expected passes      5` equivale a cinco pruebas aprobadas y cero fallos. SRFI-64 también puede escribir un log, según la configuración del runner.

### MIT/GNU Scheme + scmunit

La salida concreta depende de la versión de `scmunit` instalada. La suite está preparada para ejecutar cinco casos agrupados por método:

```text
addition
subtraction
multiplication
division
modulus
5 tests passed
```

Este resultado es la salida esperada del proyecto, pero todavía no se ha verificado en este entorno porque `scmunit.scm` no está instalado. La verificación queda pendiente de la instalación manual indicada en la sección anterior.

## 🧠 Operaciones / Operations

| Operación | Entrada | Resultado |
|-----------|---------|-----------|
| `addition` | `2, 3` | `5` |
| `subtraction` | `5, 2` | `3` |
| `multiplication` | `3, 4` | `12` |
| `division` | `10, 3` | `3` |
| `modulus` | `10, 3` | `1` |

**ES:** Lo importante es que las cinco aserciones pasen; no se exige que MIT/GNU Scheme y Guile impriman el mismo reporte textual.

**EN:** The important condition is that all five assertions pass; MIT/GNU Scheme and Guile are not required to print the same textual report.

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** La división por cero no forma parte de los casos de la especificación y produce un error explícito.
- **EN:** Division by zero is outside the specification's test cases and produces an explicit error.
- **ES:** Los nombres y operaciones del módulo son comunes a ambos intérpretes.
- **EN:** Module names and operations are shared by both interpreters.
- **ES:** `scmunit` y SRFI-64 no son intercambiables: cada suite usa la API de su runtime.
- **EN:** `scmunit` and SRFI-64 are not interchangeable: each suite uses its runtime's API.
- **ES:** Se usa una estrategia común de código y suites específicas por implementación. MIT/GNU Scheme es la ruta principal; Guile se incorpora con SRFI-64. Racket no se trata como equivalente de ninguno de los dos.
- **EN:** A shared source module and implementation-specific suites are used. MIT/GNU Scheme is the primary route; Guile is supported through SRFI-64. Racket is not treated as equivalent to either runtime.
- **ES:** Los cinco casos de prueba están agrupados por operación dentro de cada suite.
- **EN:** The five test cases are grouped by operation within each suite.

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
