# Hello, User! — Scheme

Implementación de la especificación [02_Hello_User](https://yorche3.github.io/programming_languages/core/foundations/02_Hello_User/) en **Scheme**, con un enfoque manual y minimalista.

Solicita un nombre mediante la entrada estándar y muestra un saludo personalizado.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`hello_user.scm`](hello_user.scm) | Código fuente: muestra un prompt, lee un nombre y escribe un saludo. |

**Estructura de directorios esperada:**

```text
hellouser/
├── hello_user.scm  # Código fuente
└── README.md       # Este archivo
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** Este programa amplía `helloworld` con entrada estándar. El flujo es:

1. `display` escribe el prompt.
2. `newline` termina la línea del prompt.
3. `read-line` lee el nombre introducido por el usuario.
4. `string-append` construye el saludo.
5. `display` y `newline` muestran el resultado.
6. `exit` termina explícitamente el proceso.

**EN:** This program extends `helloworld` with standard input. Its flow is:

1. `display` writes the prompt.
2. `newline` ends the prompt line.
3. `read-line` reads the user's name.
4. `string-append` builds the greeting.
5. `display` and `newline` show the result.
6. `exit` explicitly terminates the process.

### Inicialización / Initialization

1. Crear la estructura de directorios:

   ```bash
   mkdir -p scheme/core/foundations/hellouser
   ```

2. Escribir el archivo `hello_user.scm` con el código fuente.

3. Ejecutarlo con un intérprete Scheme compatible.

---

## 📄 Archivos de configuración clave / Key Configuration Files

No se requieren archivos de configuración de build ni dependencias externas. El programa utiliza procedimientos estándar de Scheme.

```scheme
(display "Enter your name: ")
(newline)
(define name (read-line))
(display (string-append "Hello, " name "!"))
(newline)
(exit)
```

| Elemento | Propósito |
|----------|-----------|
| `(display "Enter your name: ")` | Escribe el prompt en la salida estándar. |
| `(newline)` | Añade un salto de línea después del prompt. |
| `(read-line)` | Lee una línea desde la entrada estándar y devuelve su contenido como cadena. |
| `(define name ...)` | Enlaza el nombre leído a la variable `name`. |
| `(string-append ...)` | Concatena el saludo con el nombre introducido. |
| `(exit)` | Finaliza explícitamente la ejecución del programa. |

> **ES:** A diferencia de una implementación que imprime el prompt sin salto de línea, este archivo llama a `newline` inmediatamente después. Por eso la entrada y el saludo comienzan en la línea siguiente.
> **EN:** Unlike an implementation that prints the prompt without a newline, this file calls `newline` immediately afterward. Therefore, the input and greeting start on the next line.

---

## 🚀 Ejecución / Run

### Requisitos / Requirements

Se necesita un intérprete Scheme compatible con `display`, `newline`, `read-line`, `string-append` y `exit`. En este entorno se verificaron:

- **Racket**
- **MIT/GNU Scheme**

Comprobar las instalaciones:

```bash
racket --version
mit-scheme --version
```

### Ejecutar con Racket / Run with Racket

```bash
cd scheme/core/foundations/hellouser
racket -f hello_user.scm
```

### Ejecutar con MIT/GNU Scheme

```bash
cd scheme/core/foundations/hellouser
mit-scheme --quiet --load hello_user.scm
```

El programa muestra el prompt, espera una línea y después imprime el saludo.

### Ejecutar con entrada redirigida / Run with redirected input

```bash
cd scheme/core/foundations/hellouser
printf 'Ada\n' | racket -f hello_user.scm
```

También se puede usar MIT/GNU Scheme:

```bash
printf 'Ada\n' | mit-scheme --quiet --load hello_user.scm
```

### Salida esperada / Expected output

Con la entrada `Ada`, la salida real es:

```text
Enter your name: 
Hello, Ada!
```

> **ES:** El salto de línea después del prompt es intencional y el saludo añade `!` mediante la concatenación de `"Hello, "`, el nombre y `"!"`.
> **EN:** The newline after the prompt is intentional, and the greeting adds `!` by concatenating `"Hello, "`, the name, and `"!"`.

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** Scheme no requiere una función `main` para este script; las expresiones se evalúan en el orden en que aparecen.
- **EN:** Scheme does not require a `main` function for this script; expressions are evaluated in the order in which they appear.
- **ES:** `read-line` elimina el salto de línea de la entrada y devuelve el nombre como cadena.
- **EN:** `read-line` removes the input newline and returns the name as a string.
- **ES:** `hello_user.scm` puede ejecutarse directamente con los dos intérpretes verificados y no genera una estructura de build obligatoria.
- **EN:** `hello_user.scm` can be run directly with both verified interpreters and does not require a build structure.

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
