# Data Structures Advanced — Scheme

Implementación de la especificación [07_Data_Structures_Advanced](https://yorche3.github.io/programming_languages/core/algorithms/07_Data_Structures_Advanced/) en **Scheme**, con un enfoque funcional e inmutable basado en registros R7RS (`define-record-type`) y GNU Guile.

El módulo modela las estructuras requeridas (`Node`, `TreeNode`, `BinaryTree`, `GraphNode` y `Graph`). La base `Node` se reutiliza internamente por valor embebido en `TreeNode` y `GraphNode`, y las estructuras `BinaryTree` y `Graph` mantienen sus operaciones, estado y representación canónica enlazada de forma independiente y puramente inmutable.

Implementation of the [07_Data_Structures_Advanced](https://yorche3.github.io/programming_languages/core/algorithms/07_Data_Structures_Advanced/) specification in **Scheme**, using a functional and immutable approach based on R7RS records (`define-record-type`) and GNU Guile.

The module models the required structures (`Node`, `TreeNode`, `BinaryTree`, `GraphNode`, and `Graph`). The base `Node` is reused internally via an embedded value in `TreeNode` and `GraphNode`, and `BinaryTree` and `Graph` maintain their operations, state, and canonical linked representation independently and purely immutably.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo / Directory | Propósito / Purpose |
|---|---|
| [`src/data_structures_advanced.scm`](src/data_structures_advanced.scm) | Biblioteca R7RS / GNU Guile (`define-library (data_structures_advanced)`): registros, constructores y operaciones públicas para `TreeNode`, `BinaryTree` y `Graph` / Main R7RS / GNU Guile library: records, constructors, and public operations for `TreeNode`, `BinaryTree`, and `Graph` |
| [`test/data_structures_advanced_tests_guile.scm`](test/data_structures_advanced_tests_guile.scm) | Suite de pruebas unitarias para GNU Guile usando el framework SRFI-64 / Unit test suite for GNU Guile using the SRFI-64 framework |
| [`.gitignore`](.gitignore) | Exclusión de archivos de registro generados (`*.log`) / Ignored generated log files (`*.log`) |

```text
data_structures_advanced/
├── src/
│   └── data_structures_advanced.scm
├── test/
│   └── data_structures_advanced_tests_guile.scm
├── .gitignore
└── README.md
```

> **Nota de desviación / Deviation note:**  
> **ES:** La especificación sugiere la presencia de `run_tests.ext` y una suite genérica. En consonancia con la arquitectura establecida en los módulos homologados de Scheme en este monorepo (`data_structures_basics`, `numbers`), no se incluye un script `run_tests` separado; las pruebas se ejecutan directamente invocando `guile` sobre el archivo de suite correspondiente. Asimismo, el módulo se enfoca en GNU Guile debido al uso de su sistema formal de bibliotecas R7RS (`define-library`) y registros.  
> **EN:** The specification suggests the presence of `run_tests.ext` and a generic test suite. Following the pattern established across homologated Scheme modules in this monorepo (`data_structures_basics`, `numbers`), no separate `run_tests` script is included; tests are executed directly by invoking `guile` on the suite script. Furthermore, the module targets GNU Guile due to the use of its formal R7RS library system (`define-library`) and records.

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El proyecto se construyó de manera artesanal y minimalista, sin generadores automáticos de código ni herramientas de scaffolding externas. Las estructuras de datos y celdas se declaran mediante `define-record-type`. Todas las estructuras son inmutables: en lugar de modificar campos destructivamente en memoria, cada operación devuelve una nueva instancia preservando la integridad referencial. Para el grafo, se implementa un registro canónico enlazado manual por `next-vertex` con adyacencia ordenada manual, sin delegar en listas de asociación (`assoc`) ni funciones de pertenencia de biblioteca (`member`).

**EN:** The project was created manually and minimally, without automated code generators or external scaffolding tools. Data structures and cells are declared using `define-record-type`. All structures are immutable: instead of mutating fields destructively in place, each operation returns a new instance preserving referential integrity. For the graph, a manual canonical linked registry via `next-vertex` is implemented with manual sorted adjacency, without delegating to library association lists (`assoc`) or membership procedures (`member`).

---

## 📄 Configuración clave / Key Configuration

**ES:** No se requiere ningún archivo de configuración de compilación ni manifiesto de dependencias externo (como Makefiles o gestores de paquetes). GNU Guile resuelve la biblioteca cargándola con `(load "../src/data_structures_advanced.scm")` e importándola con `(use-modules (data_structures_advanced))` en tiempo de ejecución.

**EN:** No build configuration files or external dependency manifests (such as Makefiles or package managers) are required. GNU Guile resolves the library by loading it with `(load "../src/data_structures_advanced.scm")` and importing it with `(use-modules (data_structures_advanced))` at runtime.

---

## 🚀 Compilación y ejecución / Build & Run

### Requisitos / Requirements

- GNU Guile (versión 3.0.9 verificada)
- Biblioteca SRFI-64 disponible en la instalación estándar de Guile

```bash
cd scheme/core/algorithms/data_structures_advanced/test
guile --no-auto-compile -s data_structures_advanced_tests_guile.scm
```

**Salida real / Actual output:**

```text
%%%% Starting test data_structures_advanced  (Writing full log to "data_structures_advanced.log")
# of expected passes      149
```

---

## 🧠 Algoritmos y operaciones / Algorithms & Operations

| Operación / Operation | Entrada → salida / Input → output | Complejidad / Complexity | Notas / Notes |
|---|---|---|---|
| `make-tree-node` | `any → TreeNode` | $O(1)$ | Constructor de nodo de árbol con enlaces iniciales `#f` / Tree node constructor with initial `#f` links |
| `tree-node-value` | `TreeNode → any` | $O(1)$ | Retorna el valor contenido extrayéndolo de `<node>` / Returns stored value extracted from `<node>` |
| `tree-node-left` | `TreeNode → TreeNode or #f` | $O(1)$ | Retorna el hijo izquierdo o `#f` si es ausente / Returns left child or `#f` if absent |
| `tree-node-right` | `TreeNode → TreeNode or #f` | $O(1)$ | Retorna el hijo derecho o `#f` si es ausente / Returns right child or `#f` if absent |
| `tree-node-with-left` | `TreeNode, any → TreeNode` | $O(1)$ | Retorna un nodo nuevo con el enlace izquierdo actualizado / Returns a new node with updated left link |
| `tree-node-with-right` | `TreeNode, any → TreeNode` | $O(1)$ | Retorna un nodo nuevo con el enlace derecho actualizado / Returns a new node with updated right link |
| `make-binary-tree` | `— → BinaryTree` | $O(1)$ | Constructor de árbol de búsqueda binaria vacío / Empty binary search tree constructor |
| `binary-tree-insert` | `BinaryTree, any → BinaryTree` | $O(h)$ | Inserta según invariante ABB; duplicados no alteran tamaño / Inserts per BST invariant; duplicates do not grow size |
| `binary-tree-contains?` | `BinaryTree, any → bool` | $O(h)$ | Búsqueda por descenso en ABB respetando orden / BST descent search respecting order |
| `binary-tree-empty?` | `BinaryTree → bool` | $O(1)$ | Retorna `#t` si el contador es 0 / Returns `#t` if count is 0 |
| `binary-tree-size` | `BinaryTree → int` | $O(1)$ | Retorna la cantidad de nodos almacenados / Returns stored node count |
| `make-graph` | `— → Graph` | $O(1)$ | Constructor de grafo dirigido vacío / Empty directed graph constructor |
| `graph-add-vertex` | `Graph, int → Graph` | $O(V)$ | Registra vértice en registro canónico; idempotente en duplicados / Adds vertex to canonical registry; idempotent on duplicates |
| `graph-add-edge` | `Graph, int, int → Graph or #f` | $O(V + d(u))$ | Añade arista si ambos extremos existen; falla con `#f` si falta alguno / Adds edge if both endpoints exist; fails with `#f` if either missing |
| `graph-has-edge?` | `Graph, int, int → bool` | $O(V + d(u))$ | Comprueba existencia de arista dirigida / Checks directed edge existence |
| `graph-neighbors` | `Graph, int → list or #f` | $O(V)$ | Lista ordenada de vecinos, `'()` si aislado, `#f` si no existe / Sorted neighbours list, `'()` if isolated, `#f` if absent |
| `graph-empty?` | `Graph → bool` | $O(1)$ | Retorna `#t` si la cantidad de vértices es 0 / Returns `#t` if vertex count is 0 |
| `graph-vertex-count` | `Graph → int` | $O(1)$ | Retorna la cantidad de vértices registrados / Returns registered vertex count |
| `graph-edge-count` | `Graph → int` | $O(1)$ | Retorna la cantidad de aristas registradas / Returns registered edge count |

---

## 🧩 Decisiones de diseño / Design decisions

| Decisión / Decision | Alternativa considerada / Alternative | Razón / Reason |
|---|---|---|
| Inmutabilidad estructural completa / Complete structural immutability | Mutación destructiva de campos (`set-field!`) | Respeto riguroso del paradigma funcional de Scheme. Asegura aislamiento referencial, seguridad frente a efectos secundarios y persistencia estructural. |
| Reutilización de `<node>` por valor embebido / Reuse of `<node>` by embedded value | Herencia de registros o duplicación de campos | Scheme no dispone de herencia estándar entre registros SRFI-9/R7RS; encapsular `<node>` dentro de `<tree-node>` y `<graph-node>` permite reutilizar la celda de valor cumpliendo el contrato de la especificación. |
| Registro canónico enlazado manual para `Graph` / Manual canonical linked registry for `Graph` | Tablas hash o listas de asociación estándar | Cumple con la exigencia de contrato de implementar el ADT y registro canónico manualmente sin sustitutos de biblioteca opacos. |
| Adyacencia ordenada manual / Manual sorted adjacency | Ordenamiento con `sort` o búsqueda con `member`/`assoc` | Mantiene la lista de vecinos estrictamente ordenada y sin duplicados en cada inserción mediante recursión directa, sin dependencias auxiliares. |
| Encapsulamiento con R7RS `define-library` / Encapsulation with R7RS `define-library` | Carga de archivos planos sin definición de módulo | Oculta constructores internos y funciones auxiliares (`find-vertex`, `insert-label`, `update-neighbors`), exponiendo únicamente la API pública contractual. |

---

## 🔀 Adaptaciones idiomáticas / Idiomatic adaptations

| Especificación / Specification | Adaptación / Adaptation | Justificación / Justification |
|---|---|---|
| Nombres de métodos en `snake_case` (ej. `get_value`, `is_empty`) | Convención `kebab-case` de Scheme y sufijo `?` en predicados (ej. `tree-node-value`, `binary-tree-empty?`) | Convención estándar e idiomática en el ecosistema Scheme/Lisp para nombres de identificadores y predicados booleanos. |
| Mutación in-place en `set_left(node)` y `set_right(node)` | Funciones `tree-node-with-left` y `tree-node-with-right` que devuelven un nuevo `TreeNode` | Los registros son inmutables para respetar el modelo funcional; la actualización de enlace se logra instanciando un nuevo registro con el enlace modificado. |
| Mutación in-place en `add_vertex` y `add_edge` | Devolución de una nueva instancia de `Graph` | Modelo funcional inmutable donde el grafo resultante contiene el registro y contadores actualizados. |
| Ausencia nativa de enlace o retorno de fallo (`absent`) | Valor booleano `#f` | En Scheme, `#f` es la representación universal de valor ausente, centinela de fallo y puntero nulo. |
| Distinción entre vértice aislado e inexistente | Vértice aislado devuelve `'()`; vértice inexistente devuelve `#f` | Permite distinguir inequívocamente en `graph-neighbors` una adyacencia vacía válida de una consulta inválida. |
| Métodos de objeto/clase (`tree.insert(50)`) | Funciones libres que reciben la estructura como argumento (`(binary-tree-insert tree 50)`) | Scheme no utiliza orientación a objetos clásica basada en clases en su núcleo; emplea funciones puras que operan sobre registros. |

---

## 🚨 Indicadores de fallo / Failure indicators

| Operación / Operation | Situación de fallo / Failure situation | Indicador / Indicator | Ejemplo / Example |
|---|---|---|---|
| `tree-node-left` / `tree-node-right` | Enlace hijo ausente / Absent child link | `#f` | `(tree-node-left (make-tree-node 10))` → `#f` |
| `binary-tree-contains?` | Valor no encontrado en el árbol / Value not found in tree | `#f` | `(binary-tree-contains? (make-binary-tree) 50)` → `#f` |
| `graph-add-edge` | Extremo origen o destino no registrado / Source or target endpoint missing | `#f` | `(graph-add-edge (make-graph) 10 99)` → `#f` |
| `graph-has-edge?` | Arista no existente o extremos ausentes / Edge absent or endpoints missing | `#f` | `(graph-has-edge? (make-graph) 10 30)` → `#f` |
| `graph-neighbors` | Vértice consultado no existe / Queried vertex missing | `#f` | `(graph-neighbors (make-graph) 99)` → `#f` |

---

## ✅ Cobertura de pruebas / Test coverage

| Caso de la especificación / Specification case | Cubierto / Covered | Prueba / Test | Notas / Notes |
|---|---|:--:|---|
| `TreeNode`: Crear un nodo de árbol / Create a tree node | Sí | `test/data_structures_advanced_tests_guile.scm:33-36` | Verifica `tree-node-value` con valor 10 / Verifies `tree-node-value` with value 10 |
| `TreeNode`: Enlaces iniciales ausentes / Absent initial links | Sí | `test/data_structures_advanced_tests_guile.scm:38-41` | Comprueba que `tree-node-left` y `tree-node-right` son `#f` / Verifies both links are `#f` |
| `TreeNode`: Enlazar dos hijos / Link two children | Sí | `test/data_structures_advanced_tests_guile.scm:43-51` | Comprueba valores de hijos 20 y 30 / Verifies left and right child values 20 and 30 |
| `TreeNode`: Recorrer cada enlace / Traverse each link | Sí | `test/data_structures_advanced_tests_guile.scm:52-58` | Verifica navegación y enlaces ausentes en hojas / Verifies traversal and leaf absent links |
| `TreeNode`: Desenlazar hijos / Unlink children | Sí | `test/data_structures_advanced_tests_guile.scm:60-73` | Limpieza secuencial de enlaces con conservación de valores / Sequential unlinking preserving values |
| `TreeNode`: Adaptación inmutable / Immutable adaptation | Sí | `test/data_structures_advanced_tests_guile.scm:75-81` | Nodo actualizado contiene enlace y original permanece `#f` / Updated node has link, original unchanged |
| `BinaryTree`: Crear vacío / Create empty | Sí | `test/data_structures_advanced_tests_guile.scm:103-107` | Verifica `empty?` (`#t`), tamaño `0` y `contains?` (`#f`) / Verifies `empty?`, size 0, and `contains?` |
| `BinaryTree`: Insertar la raíz / Insert the root | Sí | `test/data_structures_advanced_tests_guile.scm:109-114` | Inserción exitosa, tamaño `1`, no vacío y contiene `50` / Success, size 1, not empty, contains 50 |
| `BinaryTree`: Insertar menor y mayor / Insert lower and higher | Sí | `test/data_structures_advanced_tests_guile.scm:116-118` | Inserción de 50, 30, 70; tamaño `3` y pertenencia / Inserts 50, 30, 70; size 3, all present |
| `BinaryTree`: Ramas de varios niveles / Multilevel branches | Sí | `test/data_structures_advanced_tests_guile.scm:120-122` | Inserción de 50, 30, 70, 20, 40; tamaño `5` / Inserts 5 values; size 5 and all present |
| `BinaryTree`: Valor ausente en árbol no vacío / Missing value | Sí | `test/data_structures_advanced_tests_guile.scm:124-129` | Búsqueda de 99 falla (`#f`), tamaño 1 y 50 presente / Query 99 fails (`#f`), size 1, 50 present |
| `BinaryTree`: Duplicado idempotente / Idempotent duplicate | Sí | `test/data_structures_advanced_tests_guile.scm:131-133` | Cuatro inserciones (30 duplicado); tamaño `3` / Four inserts (duplicate 30); size remains 3 |
| `BinaryTree`: Inserciones ordenadas / Ordered insertions | Sí | `test/data_structures_advanced_tests_guile.scm:135-138` | Inserción de 20, 30, 40, 50, 70; tamaño `5`, 99 ausente / Inserts sorted values; size 5, 99 absent |
| `Graph`: Crear vacío / Create empty | Sí | `test/data_structures_advanced_tests_guile.scm:182-188` | Verifica `empty?` (`#t`), contadores `0 0`, fallos de arista y vecinos / Empty, counts 0 0, queries fail |
| `Graph`: Vértice aislado / Isolated vertex | Sí | `test/data_structures_advanced_tests_guile.scm:190-194` | Registro de 10; no vacío, contadores `1 0`, vecinos `'()` / Vertex 10; not empty, counts 1 0, neighbours `'()` |
| `Graph`: Etiquetas no consecutivas y arista dirigida / Nonconsecutive labels | Sí | `test/data_structures_advanced_tests_guile.scm:196-202` | Arista 10->70 presente, inversa 70->10 ausente, contadores `2 1` / Forward present, reverse absent |
| `Graph`: Vértice duplicado conserva adyacencia / Duplicate vertex | Sí | `test/data_structures_advanced_tests_guile.scm:204-210` | Registro repetido de 10 conserva arista 10->30 y contadores `2 1` / Duplicate vertex preserves adjacency |
| `Graph`: Arista duplicada / Duplicate edge | Sí | `test/data_structures_advanced_tests_guile.scm:212-216` | Doble inserción de 10->30 mantiene contadores `2 1` y vecinos `(30)` / Duplicate edge preserves counts |
| `Graph`: Extremo inexistente sin mutación / Missing endpoint | Sí | `test/data_structures_advanced_tests_guile.scm:218-237` | Cuatro inserciones inválidas retornan `#f` sin alterar el grafo / Four invalid edges return `#f` unmutated |
| `Graph`: Vecinos ordenados y contadores / Sorted neighbours | Sí | `test/data_structures_advanced_tests_guile.scm:239-249` | Vecinos en orden creciente `(30 50 70)`, contadores `4 4` / Ascending neighbours `(30 50 70)`, counts 4 4 |
| `Graph`: Consulta de arista ausente / Missing-edge query | Sí | `test/data_structures_advanced_tests_guile.scm:251-255` | Consulta de 10->30 devuelve `#f`, contadores `2 0` / Query 10->30 returns `#f`, counts 2 0 |
| `Graph`: Vecinos de vértice inexistente / Missing vertex neighbours | Sí | `test/data_structures_advanced_tests_guile.scm:257-261` | `graph-neighbors` de 99 devuelve `#f`, distinto de `'()` / Query 99 returns `#f`, distinct from `'()` |
| `Graph`: Bucle y duplicado / Self-loop and duplicate | Sí | `test/data_structures_advanced_tests_guile.scm:263-268` | Bucle 10->10 duplicado; arista presente, vecinos `(10)`, contadores `1 1` / Self-loop present, counts 1 1 |
| `Graph`: Aislamiento del resultado de vecinos / Neighbour isolation | Sí | `test/data_structures_advanced_tests_guile.scm:270-280` | Lista de vecinos previa `(30)` permanece intacta tras nueva arista / Prior neighbours list unchanged |

> **Mapeo arquitectural / Architectural mapping:**  
> - `TreeNode / inmutable` → 6 casos → grupo lógico `"TreeNode"` → `test/data_structures_advanced_tests_guile.scm` → runner GNU Guile / SRFI-64.  
> - `BinaryTree / inmutable` → 7 casos → grupo lógico `"BinaryTree"` → `test/data_structures_advanced_tests_guile.scm` → runner GNU Guile / SRFI-64.  
> - `Graph / inmutable` → 11 casos → grupo lógico `"Graph"` → `test/data_structures_advanced_tests_guile.scm` → runner GNU Guile / SRFI-64.  
> Cada escenario ejecuta múltiples comprobaciones granulares verificando contratos, invariantes y aislamiento referencial (totalizando 149 aserciones exitosas reportadas por el runner).

---

## ⚠️ Limitaciones conocidas / Known limitations

| Limitación / Limitation | Impacto / Impact | Alternativa o plan / Workaround or plan |
|---|---|---|
| Búsqueda lineal en registro de grafo en $O(V)$ / Linear search in graph registry in $O(V)$ | Las operaciones `graph-add-vertex`, `graph-add-edge`, `graph-has-edge?` y `graph-neighbors` realizan recorrido lineal sobre el registro enlazado canónico. | Consecuencia directa del diseño puramente funcional con estructuras enlazadas manuales canónicas sin indexación por arrays ni tablas hash. Es conforme a la complejidad contratada $O(V + d(u))$ de la especificación. |

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** La implementación sigue estrictamente un diseño funcional e inmutable. Las operaciones que actualizan estructuras (`tree-node-with-left`, `tree-node-with-right`, `binary-tree-insert`, `graph-add-vertex`, `graph-add-edge`) devuelven instancias nuevas sin mutar destructivamente las anteriores.
- **EN:** The implementation strictly follows a functional and immutable design. Operations updating structures (`tree-node-with-left`, `tree-node-with-right`, `binary-tree-insert`, `graph-add-vertex`, `graph-add-edge`) return new instances without destructively mutating previous ones.
- **ES:** Se definen los registros mediante R7RS `define-record-type` (`<node>`, `<tree-node>`, `<binary-tree>`, `<graph-node>`, `<graph>`). La base `<node>` contiene únicamente el campo de valor sin enlaces ni validaciones y se reutiliza internamente por valor embebido en `<tree-node>` y `<graph-node>`.
- **EN:** Records are defined via R7RS `define-record-type` (`<node>`, `<tree-node>`, `<binary-tree>`, `<graph-node>`, `<graph>`). The `<node>` base contains only the value field without links or validations and is reused internally via embedded value in `<tree-node>` and `<graph-node>`.
- **ES:** El árbol de búsqueda binaria implementa inserción y comprobación de pertenencia por descenso recursivo respetando la invariante del ABB (menores a la izquierda, mayores a la derecha).
- **EN:** The binary search tree implements insertion and membership checking via recursive descent respecting the BST invariant (smaller left, greater right).
- **ES:** El grafo no delega en mapas ni listas de asociación de biblioteca; utiliza un registro enlazado manual canónico por `next-vertex` y mantiene las listas de adyacencia ordenadas crecientemente sin duplicados.
- **EN:** The graph does not delegate to library maps or association lists; it uses a manual canonical linked registry via `next-vertex` and maintains adjacency lists in ascending order without duplicates.
- **ES:** Las consultas de fallo devuelven `#f`. En `graph-neighbors`, un vértice existente aislado retorna `'()`, mientras que un vértice inexistente retorna `#f`.
- **EN:** Failure queries return `#f`. In `graph-neighbors`, an existing isolated vertex returns `'()`, whereas a nonexistent vertex returns `#f`.

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
| Especificación / Specification | [`07_Data_Structures_Advanced.md`](../../../../docs/core/algorithms/07_Data_Structures_Advanced.md) |
| Primera base del lenguaje / First language reference | `data_structures_basics` — [`scheme/core/algorithms/data_structures_basics/`](../data_structures_basics/) |
| Segunda base del lenguaje / Second language reference | `numbers` — [`scheme/core/foundations/numbers/`](../../foundations/numbers/) |
| Guía de inicialización / Initialisation guide | [`core/00_Project_Initialization_Guide.md`](../../../../docs/core/00_Project_Initialization_Guide.md) |
| Adaptaciones idiomáticas / Idiomatic adaptations | [`AGENT_Template.md`](../../../../docs/AGENT_Template.md) |
| Validación de la documentación / Documentation validation | [`WORKFLOW.md`](../../../../docs/WORKFLOW.md) |
| Documentación oficial del lenguaje / Language official docs | [GNU Guile Reference Manual](https://www.gnu.org/software/guile/manual/) |

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
