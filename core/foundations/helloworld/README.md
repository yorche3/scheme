# Hello, World! — Scheme

Implementación de la especificación [01_Hello_World](https://yorche3.github.io/programming_languages/core/foundations/01_Hello_World/) en **Scheme**, con un enfoque manual y minimalista.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`hello_world.scm`](hello_world.scm) | Código fuente: escribe un saludo en la salida estándar y termina la ejecución. |

**Estructura de directorios esperada:**

```text
helloworld/
├── hello_world.scm  # Código fuente
└── README.md        # Este archivo
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El proyecto se creó manualmente, sin herramientas de scaffolding ni dependencias externas. Un único archivo `.scm` es suficiente: el programa se evalúa directamente mediante un intérprete Scheme.

**EN:** The project was created manually, without scaffolding tools or external dependencies. A single `.scm` file is enough: the program is evaluated directly by a Scheme interpreter.

El flujo del programa es:

1. `display` escribe el saludo sin añadir automáticamente un salto de línea.
2. `newline` añade el salto de línea final.
3. `exit` termina explícitamente el proceso.

### Inicialización / Initialization

1. Crear la estructura de directorios:

   ```bash
   mkdir -p scheme/core/foundations/helloworld
   ```

2. Escribir el archivo `hello_world.scm` con el código fuente.

3. Ejecutarlo con un intérprete Scheme compatible.

---

## 📄 Archivos de configuración clave / Key Configuration Files

No se requieren archivos de configuración de build. El programa utiliza únicamente procedimientos estándar de Scheme.

```scheme
(display "Hello, World! from Scheme")
(newline)
(exit)
```

| Elemento | Propósito |
|----------|-----------|
| `(display ...)` | Escribe la cadena en la salida estándar sin añadir un salto de línea. |
| `(newline)` | Escribe un salto de línea en la salida estándar. |
| `(exit)` | Finaliza explícitamente la ejecución del programa. |
| `"Hello, World! from Scheme"` | Cadena que se muestra al usuario. |

---

## 🚀 Ejecución / Run

### Requisitos / Requirements

Se necesita una implementación Scheme compatible con `display`, `newline` y `exit`. En este entorno se verificaron:

- **MIT/GNU Scheme**
- **GNU Guile**

Comprobar las instalaciones:

```bash
mit-scheme --version
guile --version
```

### Ejecutar con MIT/GNU Scheme

```bash
cd scheme/core/foundations/helloworld
mit-scheme --quiet --load hello_world.scm
```

### Ejecutar con GNU Guile / Run with GNU Guile

```bash
cd scheme/core/foundations/helloworld
guile -s hello_world.scm
```

### Salida esperada / Expected output

```text
Hello, World! from Scheme
```

La salida verificada con MIT/GNU Scheme y GNU Guile es equivalente y contiene un salto de línea al final.

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** Scheme no requiere una función `main` para este script; las expresiones se evalúan en el orden en que aparecen.
- **EN:** Scheme does not require a `main` function for this script; expressions are evaluated in the order in which they appear.
- **ES:** `display` se utiliza en lugar de `print` para evitar una representación decorada de la cadena.
- **EN:** `display` is used instead of `print` to avoid a decorated representation of the string.
- **ES:** El archivo usa la extensión `.scm` y no necesita una línea `#lang`, por lo que puede ejecutarse con MIT/GNU Scheme y GNU Guile.
- **EN:** The file uses the `.scm` extension and does not need a `#lang` line, so it can be run by MIT/GNU Scheme and GNU Guile.

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
