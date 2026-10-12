# Data Structures Basics — Scheme

Implementación de la especificación [06_Data_Structures_Basics](https://yorche3.github.io/programming_languages/core/algorithms/06_Data_Structures_Basics/) en **Scheme**, con un enfoque funcional e inmutable basado en registros de SRFI-9 y GNU Guile.

El módulo modela las cuatro estructuras requeridas (`Node`, `LinkedList`, `Stack` y `Queue`) sobre un único tipo de nodo compartido inmutable, implementando sus operaciones sin dependencias entre estructuras y sin delegar en colecciones estándar.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo / Directory | Propósito / Purpose |
|---|---|
| [`src/data_structures_basics.scm`](src/data_structures_basics.scm) | Módulo principal GNU Guile (`define-module`): registros SRFI-9, constantes vacías y procedimientos de las 4 estructuras / Main GNU Guile module: SRFI-9 records, empty constants, and operations for all 4 structures |
| [`test/data_structures_basics_tests_guile.scm`](test/data_structures_basics_tests_guile.scm) | Suite de pruebas unitarias para GNU Guile usando el framework SRFI-64 / Unit test suite for GNU Guile using SRFI-64 framework |
| [`.gitignore`](.gitignore) | Exclusión de archivos de registro generados (`*.log`) / Ignored generated log files (`*.log`) |

```text
data_structures_basics/
├── src/
│   └── data_structures_basics.scm
├── test/
│   └── data_structures_basics_tests_guile.scm
├── .gitignore
└── README.md
```

> **Nota de desviación / Deviation note:**  
> **ES:** La especificación sugiere la presencia de `run_tests.ext` y una suite genérica. En consonancia con la arquitectura establecida en los módulos homologados de Scheme en este monorepo, no se incluye un script `run_tests` separado; las pruebas se ejecutan directamente invocando `guile` sobre el archivo de suite correspondiente. Asimismo, el módulo se enfoca exclusivamente en GNU Guile debido al uso de su sistema formal de módulos (`define-module`) y registros SRFI-9.  
> **EN:** The specification suggests the presence of `run_tests.ext` and a generic test suite. Following the pattern established across homologated Scheme modules in this monorepo, no separate `run_tests` script is included; tests are executed directly by invoking `guile` on the suite script. Furthermore, the module targets GNU Guile exclusively due to the use of its formal module system (`define-module`) and SRFI-9 records.

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El proyecto se construyó de manera artesanal y minimalista, sin generadores automáticos de código ni herramientas de scaffolding externas. Las estructuras de datos y celdas se declaran mediante `define-record-type` de SRFI-9. Todas las estructuras son inmutables: en lugar de modificar campos en memoria destructivamente, cada operación de inserción o eliminación devuelve una nueva instancia preservando la integridad referencial.

**EN:** The project was created manually and minimally, without automated code generators or external scaffolding tools. Data structures and cells are declared using SRFI-9's `define-record-type`. All structures are immutable: instead of mutating fields destructively in place, each insertion or removal operation returns a new instance preserving referential integrity.

---

## 📄 Configuración clave / Key Configuration

**ES:** No se requiere ningún archivo de configuración de compilación ni manifiesto de dependencias externo (como Makefiles o gestores de paquetes). GNU Guile resuelve el módulo cargándolo con `(load "../src/data_structures_basics.scm")` y activándolo con `(use-modules (data_structures_basics))` en tiempo de ejecución.

**EN:** No build configuration files or external dependency manifests (such as Makefiles or package managers) are required. GNU Guile resolves the module by loading it with `(load "../src/data_structures_basics.scm")` and activating it with `(use-modules (data_structures_basics))` at runtime.

---

## 🚀 Compilación y ejecución / Build & Run

### Requisitos / Requirements

- GNU Guile (versión 3.0.9 verificada)
- Biblioteca SRFI-64 disponible en la instalación estándar de Guile

```bash
cd scheme/core/algorithms/data_structures_basics/test
guile --no-auto-compile -s data_structures_basics_tests_guile.scm
```

**Salida real / Actual output:**

```text
%%%% Starting test data_structures_basics  (Writing full log to "data_structures_basics.log")
# of expected passes      85
```

---

## 🧠 Algoritmos y operaciones / Algorithms & Operations

| Operación / Operation | Entrada → salida / Input → output | Complejidad / Complexity | Notas / Notes |
|---|---|---|---|
| `make-node` | `any, any → Node` | $O(1)$ | Constructor directo de celda compartida / Direct shared cell constructor |
| `node?` | `any → bool` | $O(1)$ | Predicado de tipo para `Node` / Type predicate for `Node` |
| `node-value` | `Node → any` | $O(1)$ | Retorna el valor contenido / Returns stored value |
| `node-next` | `Node → Node or #f` | $O(1)$ | Retorna el nodo siguiente o `#f` / Returns next node or `#f` |
| `node-with-next` | `Node, any → Node` | $O(1)$ | Retorna un nodo nuevo con el enlace actualizado / Returns a new node with updated link |
| `empty-linked-list` | `— → LinkedList` | $O(1)$ | Constante con lista vacía inicializada / Initialized empty list constant |
| `linked-list?` | `any → bool` | $O(1)$ | Predicado de tipo para `LinkedList` / Type predicate for `LinkedList` |
| `linked-list-empty?` | `LinkedList → bool` | $O(1)$ | Retorna `#t` si el tamaño es 0 / Returns `#t` if size is 0 |
| `linked-list-size` | `LinkedList → int` | $O(1)$ | Retorna el número de elementos / Returns element count |
| `linked-list-head` | `LinkedList → int` | $O(1)$ | Valor de cabeza o `-1` si está vacía / Head value or `-1` if empty |
| `linked-list-insert-head` | `LinkedList, any → LinkedList` | $O(1)$ | Inserta elemento en la cabeza / Prepends element to head |
| `linked-list-insert-tail` | `LinkedList, any → LinkedList` | $O(n)$ | Reconstruye cadena para enlazar al final / Rebuilds chain to append at tail |
| `linked-list-delete` | `LinkedList, any → LinkedList or #f` | $O(n)$ | Elimina primera aparición o `#f` si no existe / Removes first occurrence or `#f` if absent |
| `empty-stack` | `— → Stack` | $O(1)$ | Constante con pila vacía inicializada / Initialized empty stack constant |
| `stack?` | `any → bool` | $O(1)$ | Predicado de tipo para `Stack` / Type predicate for `Stack` |
| `stack-empty?` | `Stack → bool` | $O(1)$ | Retorna `#t` si el tamaño es 0 / Returns `#t` if size is 0 |
| `stack-size` | `Stack → int` | $O(1)$ | Retorna el número de elementos / Returns element count |
| `stack-push` | `Stack, any → Stack` | $O(1)$ | Apila elemento sobre la cima / Pushes element to top |
| `stack-pop` | `Stack → (value . Stack) or #f` | $O(1)$ | Extrae cima y retorna par con pila nueva o `#f` / Pops top returning pair with new stack or `#f` |
| `stack-peek` | `Stack → int` | $O(1)$ | Valor de la cima o `-1` si está vacía / Top value or `-1` if empty |
| `empty-queue` | `— → Queue` | $O(1)$ | Constante con cola vacía inicializada / Initialized empty queue constant |
| `queue?` | `any → bool` | $O(1)$ | Predicado de tipo para `Queue` / Type predicate for `Queue` |
| `queue-empty?` | `Queue → bool` | $O(1)$ | Retorna `#t` si el tamaño es 0 / Returns `#t` if size is 0 |
| `queue-size` | `Queue → int` | $O(1)$ | Retorna el número de elementos / Returns element count |
| `queue-enqueue` | `Queue, any → Queue` | $O(n)$ | Reconstruye cadena para encolar al final / Rebuilds chain to append at rear |
| `queue-dequeue` | `Queue → (value . Queue) or #f` | $O(1)$ | Extrae frente y retorna par con cola nueva o `#f` / Dequeues front returning pair with new queue or `#f` |
| `queue-peek` | `Queue → int` | $O(1)$ | Valor del frente o `-1` si está vacía / Front value or `-1` if empty |

---

## 🧩 Decisiones de diseño / Design decisions

| Decisión / Decision | Alternativa considerada / Alternative | Razón / Reason |
|---|---|---|
| Estructuras y nodos inmutables / Immutable structures and nodes | Celdas mutables con `set-car!`/`set-cdr!` o records mutables (`set-field!`) | Alineación con el paradigma funcional idiomático de Scheme. Proporciona seguridad referencial y persistencia estructural sin efectos secundarios. |
| Devolución de pares `(valor . nueva-estructura)` en `pop` y `dequeue` / Return pairs `(value . new-structure)` in `pop` and `dequeue` | Valores múltiples mediante `values` o mutación destructiva | Facilita el encadenamiento composicional funcional y permite desempaquetar limpiamente con `car`/`cdr` sin depender de construcciones complejas como `call-with-values`. |
| Uso de constantes `empty-*` para inicialización / Use of `empty-*` constants for initialization | Funciones constructoras vacías `(init)` | En un diseño puramente inmutable, una instancia vacía no contiene estado variable, por lo que compartir una constante única ahorra asignaciones innecesarias de memoria. |
| Módulo formal GNU Guile (`define-module`) / Formal GNU Guile module (`define-module`) | Carga de archivos planos sin sistema de módulos | Proporciona encapsulamiento adecuado de funciones auxiliares (`chain-values`, `chain-from-values`, `remove-first-value`), exponiendo únicamente el contrato público. |

---

## 🔀 Adaptaciones idiomáticas / Idiomatic adaptations

| Especificación / Specification | Adaptación / Adaptation | Justificación / Justification |
|---|---|---|
| Nombres de métodos en `snake_case` (ej. `get_head`, `is_empty`) | Convención `kebab-case` de Scheme (ej. `linked-list-head`, `linked-list-empty?`) | Convención estándar e idiomática en el ecosistema Scheme/Lisp para nombres de identificadores y predicados terminados en `?`. |
| Mutación in-place en `set_next(next)` | Función `node-with-next` devolviendo un nuevo `Node` | Los registros definidos son inmutables para respetar el modelo funcional; la actualización de enlace se logra instanciando una nueva celda. |
| Complejidad $O(1)$ en `insert_tail` y `enqueue` | Complejidad $O(n)$ en `linked-list-insert-tail` y `queue-enqueue` | Debido a la inmutabilidad de los nodos, enlazar un elemento al final de una lista simplemente enlazada requiere reconstruir el camino de nodos precedente. |
| Ausencia nativa de enlace (`absent`) | Valor booleano `#f` | En Scheme `#f` es la representación universal de valor ausente, centinela de fallo y puntero nulo. |
| Métodos de clase / OO (`obj.pop()`) | Funciones libres que reciben la estructura como argumento (`(stack-pop stack)`) | Scheme no emplea orientación a objetos clásica basada en clases en su núcleo; utiliza funciones puras que operan sobre tipos de registro. |

---

## 🚨 Indicadores de fallo / Failure indicators

| Operación / Operation | Situación de fallo / Failure situation | Indicador / Indicator | Ejemplo / Example |
|---|---|---|---|
| `node-next` | Enlace siguiente ausente / Absent next link | `#f` | `(node-next (make-node 42 #f))` → `#f` |
| `linked-list-head` | Lista vacía / Empty list | `-1` | `(linked-list-head empty-linked-list)` → `-1` |
| `linked-list-delete` | Valor no encontrado o lista vacía / Value not found or empty list | `#f` | `(linked-list-delete empty-linked-list 10)` → `#f` |
| `stack-peek` | Pila vacía / Empty stack | `-1` | `(stack-peek empty-stack)` → `-1` |
| `stack-pop` | Pila vacía / Empty stack | `#f` | `(stack-pop empty-stack)` → `#f` |
| `queue-peek` | Cola vacía / Empty queue | `-1` | `(queue-peek empty-queue)` → `-1` |
| `queue-dequeue` | Cola vacía / Empty queue | `#f` | `(queue-dequeue empty-queue)` → `#f` |

---

## ✅ Cobertura de pruebas / Test coverage

| Caso de la especificación / Specification case | Cubierto / Covered | Prueba / Test | Notas / Notes |
|---|---|:--:|---|
| `Node`: Inicializar y observar valor/enlace / Initialize and observe value/link | Sí | `test/data_structures_basics_tests_guile.scm:42-48` | Comprueba `node-value` (42) y `node-next` ausente (`#f`). |
| `Node`: Inicializar otro nodo, enlazar y recorrer / Initialize another node, link and traverse | Sí | `test/data_structures_basics_tests_guile.scm:50-60` | Comprueba `node-with-next`, navegación al segundo nodo y enlace ausente. |
| `LinkedList`: Estado vacío / Empty state | Sí | `test/data_structures_basics_tests_guile.scm:66-76` | Verifica `linked-list-empty?` (`#t`), `linked-list-size` (`0`) y `linked-list-head` (`-1`). |
| `LinkedList`: Insertar por ambos extremos / Insert at both ends | Sí | `test/data_structures_basics_tests_guile.scm:78-121` | Comprueba inserciones en cabeza y cola, tamaño acumulado y cabeza visible. |
| `LinkedList`: Eliminar primera aparición / Delete first occurrence | Sí | `test/data_structures_basics_tests_guile.scm:133-143` | Elimina cabeza, cola y elemento intermedio verificando la preservación del orden. |
| `LinkedList`: Valor ausente / Absent value | Sí | `test/data_structures_basics_tests_guile.scm:152-154` | Elimina un valor inexistente (99) esperando `#f`. |
| `LinkedList`: Vaciar / Empty the list | Sí | `test/data_structures_basics_tests_guile.scm:162-178` | Vaciado completo mediante sucesivos deletes, verificación de estado vacío y posterior reutilización. |
| `Stack`: Estado vacío y extracción fallida / Empty state and failed removal | Sí | `test/data_structures_basics_tests_guile.scm:203-217` | Verifica `stack-empty?` (`#t`), `stack-size` (`0`), `stack-peek` (`-1`) y `stack-pop` (`#f`). |
| `Stack`: LIFO y `peek` no mutante / LIFO and non-mutating `peek` | Sí | `test/data_structures_basics_tests_guile.scm:219-238` | Empuja 3 elementos, comprueba `stack-peek` (`30`) y tamaño (`3`). |
| `Stack`: Extracción y reutilización / Removal and reuse | Sí | `test/data_structures_basics_tests_guile.scm:239-270` | Sucesión de pops y push (orden LIFO 30, 40, 20, 10), vaciado y reutilización. |
| `Stack`: Vacío tras extracción / Empty after removal | Sí | `test/data_structures_basics_tests_guile.scm:262-264` | `stack-pop` sobre pila vaciada devuelve `#f` y conserva estado vacío. |
| `Queue`: Estado vacío y extracción fallida / Empty state and failed removal | Sí | `test/data_structures_basics_tests_guile.scm:300-314` | Verifica `queue-empty?` (`#t`), `queue-size` (`0`), `queue-peek` (`-1`) y `queue-dequeue` (`#f`). |
| `Queue`: FIFO y `peek` no mutante / FIFO and non-mutating `peek` | Sí | `test/data_structures_basics_tests_guile.scm:316-335` | Encola 3 elementos, comprueba `queue-peek` (`1`) y tamaño (`3`). |
| `Queue`: Extracción y reutilización / Removal and reuse | Sí | `test/data_structures_basics_tests_guile.scm:336-367` | Sucesión de dequeues y enqueue (orden FIFO 1, 2, 3, 4), vaciado y reutilización. |
| `Queue`: Vacío tras extracción / Empty after removal | Sí | `test/data_structures_basics_tests_guile.scm:359-361` | `queue-dequeue` sobre cola vaciada devuelve `#f` y conserva estado vacío. |

---

## ⚠️ Limitaciones conocidas / Known limitations

| Limitación / Limitation | Impacto / Impact | Alternativa o plan / Workaround or plan |
|---|---|---|
| Inserción al final en $O(n)$ / Tail insertion in $O(n)$ | `linked-list-insert-tail` y `queue-enqueue` operan en tiempo lineal debido a la inmutabilidad de los nodos y estructuras. | Consecuencia intrínseca de usar listas enlazadas inmutables puras sin mutación interna (`set-cdr!`). Para operaciones en tiempo constante en colas puramente funcionales, fases avanzadas explorarán colas de Okasaki (dos listas inversas). |

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** La implementación sigue estrictamente un diseño funcional e inmutable. A diferencia de las estructuras imperativas donde `pop` o `dequeue` mutan el contenedor y retornan el elemento extraído, en Scheme estas operaciones retornan un par ordenado `(cons valor nueva-estructura)` en caso de éxito, o `#f` si la estructura está vacía.
- **EN:** The implementation strictly follows a functional and immutable design. Unlike imperative structures where `pop` or `dequeue` mutate the container and return the extracted element, in Scheme these operations return a cons pair `(cons value new-structure)` on success, or `#f` if the structure is empty.
- **ES:** Se definen los registros mediante SRFI-9 (`<node>`, `<linked-list>`, `<stack>`, `<queue>`). Cada estructura mantiene su propio contador y sus punteros correspondientes, compartiendo únicamente el tipo `<node>` sin delegar ninguna operación lógica en `LinkedList`.
- **EN:** Records are defined via SRFI-9 (`<node>`, `<linked-list>`, `<stack>`, `<queue>`). Each structure maintains its own counter and respective pointers, sharing only the `<node>` record without delegating any logical operation to `LinkedList`.
- **ES:** En lecturas de enteros sobre estructuras vacías (`linked-list-head`, `stack-peek`, `queue-peek`), se retorna el indicador centinela `-1`, evitando lanzar excepciones o condiciones de error.
- **EN:** For integer reads on empty structures (`linked-list-head`, `stack-peek`, `queue-peek`), the sentinel indicator `-1` is returned, avoiding throwing exceptions or error conditions.

---

## 🔍 Checklist de validación / Validation checklist

- [x] La suite nativa se ejecutó y su salida real está copiada en este README.
- [x] Cada caso de la especificación tiene su fila en _Cobertura de pruebas_ (o `Omitido` con razón).
- [x] Cada desviación del pseudocódigo o de la ubicación esperada está en _Adaptaciones idiomáticas_.
- [x] Cada operación con fallo posible está en _Indicadores de fallo_.
- [x] No hay rutas absolutas del autor, credenciales ni salidas inventadas.
- [x] Los enlaces relativos resuelven dentro del repositorio y el documento es bilingüe.
- [x] Ninguna sección repite lo que ya dice la especificación.

---

## 📚 Referencias / References

| Tipo / Kind | Referencia / Reference |
|---|---|
| Especificación / Specification | [`06_Data_Structures_Basics.md`](../../../../docs/core/algorithms/06_Data_Structures_Basics.md) |
| Módulo homologado del lenguaje / Homologated module | [`scheme/core/foundations/numbers/`](../../foundations/numbers/) |
| Guía de inicialización / Initialisation guide | [`core/00_Project_Initialization_Guide.md`](../../../../docs/core/00_Project_Initialization_Guide.md) |
| Adaptaciones idiomáticas / Idiomatic adaptations | [`AGENT_Template.md`](../../../../docs/AGENT_Template.md) |
| Validación de la documentación / Documentation validation | [`WORKFLOW.md`](../../../../docs/WORKFLOW.md) |
| Documentación oficial del lenguaje / Language official docs | [GNU Guile Reference Manual](https://www.gnu.org/software/guile/manual/) |

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
