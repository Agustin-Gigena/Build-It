# Análisis de mercado: SaaS B2B local — Campana/Zárate/Escobar/Capilla

**Fecha:** 2026-10-29 · **Estado:** EN INVESTIGACIÓN — sin decisión final, sin commit
**Autor del análisis:** sesión de brainstorming con Agustín Gigena (agigena.com)

## 1. Restricciones y objetivo

| Restricción | Valor |
|---|---|
| Forma del producto | **Web + app MAUI** (shell Android ya compila en `feat/arquitectura-monorepo`) — la app móvil aplica según el nicho (ej.: portal de familias, campo sin señal) |
| Base | Campana, Buenos Aires (no Tigre) |
| Tiempo | <10 h/semana (trabajo 8-5 en Alephoo) |
| Presupuesto | ~$0/mes |
| Objetivo | Ingreso extra → a futuro, trabajo principal |
| Contrato | No-competencia/exclusividad con Alephoo → **salud descartado** |
| Red de contactos | 1-4 (distribución aún teórica) |
| Stack | .NET/C#, AWS (10+ servicios), Docker/K8s, CI/CD, ISO 27001 |
| Activo existente | RugbyEngine: 50 usuarios activos |

## 2. Contexto macro (con fuentes)

- Precio típico SaaS vertical AR: **$18.000–47.000/mes** ([VetApp](https://vet-app.com.ar/precios) $18k, [Fudo](https://fu.do/es-ar/precios/) $22.5k, [Midu](https://midu.app/precios) $47k).
- Cobro recurrente resuelto: MercadoPago Suscripciones; tasas oct-2026: link 6,29%+IVA instante / 1,49% a 35 días; QR débito 1,35%+IVA; [Mobbex suscripciones 3,9%+IVA](https://www.mobbex.com/planes). Fuente detallada: [SODI 21/10/2026](https://sodi.com.ar/blog/como-reducir-comisiones-mercadopago). Buenos Aires paga ~0,3 pts más. Cuotas sin interés: 10,49%–41,59% + IVA extra — nunca por defecto.
- Adopción IA pymes: 54% en las Américas ([Microsoft 2025](https://news.microsoft.com/source/latam/noticias-de-microsoft/encuesta-pymes-2025-54-de-las-pymes-en-las-americas-usa-ia)); vertical SaaS es la tendencia ([Forbes LATAM](https://forbes.co/2024/04/26/red-forbes/saas-vertical-en-america-latina-oportunidades-y-desafios-en-un-mercado-emergente)).
- Infra propia estimada: USD 40-90/mes en AWS; alternativa boring: VPS USD 10-20. Punto de equilibrio: 1-3 clientes.

## 3. Atlas de verticales (densidad medida)

| # | Vertical | Competidores | Densidad | Veredicto |
|---|---|---|---|---|
| 1 | Consultoras de Seguridad e Higiene | **[Inditia Safe](https://inditia.com/precios)** — freemium completo y self-serve: Base gratis (1 empresa/6 módulos), Profesional $34.900/mes, Estudio $79.900/mes, Corporativo desde $199.000/mes; 18 módulos, normativa AR, MercadoPago, cobro en pesos. Lado contratistas: [Penta Uno](https://pentauno.com.ar/soluciones/gestion-de-contratistas), Clave 10, Verdana, Highseg | 🔴 Cerrado | **Vertical cerrado 29/10**: Inditia ejecutó exactamente el playbook que habríamos propuesto (freemium + self-serve + pesos). No hay fisura remanente identificable por internet |
| 2 | Jardines de nivel inicial (self-serve interior) | [Gestión Inicial](https://gestioninicial.com.ar/) (fuerte, sales-led, sin precio público), [Escuela Digital](https://escueladigital.ar/), [Cometa](https://cometaedu.com/productos/cobranzas), SIRO | 🟡 Media | Ventana angosta: la cola larga del interior sin demo/capacitación |
| 3 | Institutos de cursos/idiomas | [AKDEMIApp](https://akdemiapp.com/) (freemium), Playoff, Algebraix/mattilda | 🔴 | Cerrada |
| 4 | Consorcios/expensas | KM44 (gratis), Visorcio, Habita, TuExpense, MisExpensas, +4 | 🔴 | Descartado |
| 5 | Veterinarias | VetApp, VetFlow, Volki, Vetnube, ACVet, GVET, Trud | 🔴 | Descartado |
| 6 | Talleres mecánicos | TallerPro, Vehix (IA), Mecaris, Mechsys, TallerON, Mechify, STApp | 🔴 | Descartado |
| 7 | Complejos deportivos/pádel | ATC, Playtomic, easycancha, DóndeJuego, HayCanchas, Gerix, CanchaNube, repe.club, CanchaFija | 🔴 | Descartado |
| 8 | Clubes institucionales | rql, Lila, Clupik + [Conecta Rugby APP UAR gratis (jun 2026)](https://uar.com.ar/conecta-rugby-app-la-nueva-aplicacion-movil-para-potenciar-la-gestion-y-capacitacion-del-rugby-argentino) | 🔴 | Descartado |
| 9 | Gastronomía/delivery | PedidosYa dominante | 🔴 | Descartado |
| 10 | Turnos salud/estética | AgendaPro ya opera en Campana/Zárate ([ej. local](https://agendapro.com/mp/ar/pl/panda-veterinary-clinic/623858)), Doctoralia | 🔴 | Descartado |
| 11 | Transporte/logística chica | Marketplaces de carga: [CargARG](https://cargarg.com/), [Ruta Llena](https://rutallena.com/), [Ruteo](https://ruteo.ar/), [TCargo](https://tcargo.app/) (peajes); [Rutazo](https://www.rutazo.com/marketplace-de-cargas) ya incluye gestión de transportista (gastos, vencimientos). Gestión pura del transportista chico en AR: sin jugador dedicado detectado (Control Ruta es Chile) | 🟡 Baja-media | Payer débil (transportista unipersonal, márgenes finos, churn alto). Fisura real pero de mala economía |
| 12 | Geriátricos/residencias | [SGG](https://www.sggsoftware.com.ar/), [Gentrix](https://www.gentrix.ar/), [GeriGestión](https://gerigestion.com/), GERIGES, [InReside](https://inreside.com.ar/), GEROSALUS, [Orbi](https://orbi.care/) | 🔴 | Descartado (además riesgo no-compete: dominio salud-adyacente a Alephoo) |
| 13 | Inmobiliarias chicas/alquileres | [Rentaloop](https://rentaloop.com.ar/), [Domus](https://gestiondomus.com/), [BAUP](https://baup.com.ar/) (IA), SimpleProp, Domexa, [Adero](https://adero.com.ar/), Rentix Pro, SolProp | 🔴 | Descartado |
| 14 | Corralones/ferreterías | Flexxus, XPyME, Dropex, Sistemas Integrados, Dux (desde $36k+IVA), comparativas 2026 | 🔴 | Descartado: ERP commodity |
| 15 | Seguridad privada (empresas CAP) | Control de ronda vendido por monitoreadoras ([ByV VIGICONTROL](https://www.byvseguridad.com.ar/), Control24); SOC internacional: [Centinela](https://centinela.com.ec/), Anolla. Sin SaaS AR dedicado a pymes CAP detectado | 🟡 Baja-media | Regulación fuerte (Ley 12.297, habilitaciones CAP, legajos) = dolor real; Zárate/Campana tienen varias CAP. Venta B2B a dueños de seguridad: difícil. Candidato #3, detrás de jardines |

## 4. Adopción local detectada (inventario Campana/Zárate/Escobar/Capilla)

- E-commerce local sobre TiendaNube ([ej.](https://www.withme.ar/)); delivery vía PedidosYa; reservas deportivas vía ATC/Playtomic; turnos vía AgendaPro/Doctoralia. **Los rubros "fáciles" ya tienen jugador nacional operando localmente.**
- Servicios industriales (fumigación, SHT, mantenimiento): solo web corporativa + WhatsApp + Excel. **Único rubro sin sistema detectado.**
- Educación: sin detección local de plataformas.
- ⚠️ Descartado como fuente: artículo "Changuito #1" de zaratecampana.com — advertorial SEO con premios/cámaras inverificables.

## 5. Deep dive: nivel inicial y cursos

- Gestión Inicial: producto maduro y específico (reporte diario maternal, portal familias, cobranzas, legajos). Sales-led → apunta a jardines grandes de CABA/GBA. Brecha: self-serve barato para 50-100 jardines del interior [estimación de mercado, sin verificar].
- Cobranzas educativas ya resuelta por Cometa + débito SIRO. Cursos: AKDEMIApp freemium cerró la ventana.

## 6. Deep dive: escuelas privadas (3 pisos)

Colegios grandes cerrados (SGE + débito SIRO); piso medio (jardines/apoyo) = único atacable; institutos fuera. Techo en los 4 partidos: ~$200-400k/mes → útil como extra, insuficiente como sueldo.

## 8. Exploración global en USD (abierta 29/10, ronda 1)

**Rieles de cobro resueltos:**
- Lemon Squeezy como Merchant of Record (~5% + $0.50): maneja IVA global, suscripciones, payouts. Rieles estándar de indie hackers AR 2026 ([stack indie 2026](https://pasqualepillitteri.it/es/news/3087/stack-indie-hacker-espana-mexico-argentina-2026)).
- Exportación de servicios en monotributo: facturación al exterior con tratamiento favorable ([ARCA](https://www.arca.gob.ar/monotributo/exportacion-servicios), [guía 2026](https://rualareu.com/blog/exportacion-servicios-2026-factura-e-freelancers)); BCRA tiene reglas de ingreso de divisas ([detalles](https://todoparamonotributistas.com/exportacion-de-servicios-como-cobrar-dolares-bcra)).
- Apple/Google Store (15-30%): son su propio MoR — cero trabajo fiscal a cambio de comisión.

**Arquetipos evaluados contra el perfil (.NET/AWS/MAUI, <10h, 1 persona):**

| Arquetipo | Distribución | Monetización | Fit | Evidencia de techo |
|---|---|---|---|---|
| **App Shopify (marketplace-attached)** | El App Store trae los merchants | Billing API recurrente nativa | Media-alta: backend .NET ok; frontend embedded en React/Rails | Ecosistema USD 1.3B ([Shopify 2026](https://www.shopify.com/news/billion-dollar-ecosystem)); encuesta 165 founders: 25% >$10k MRR, 32% $0 ([datos](https://x.com/DsMatie/status/2080264644917100546)); caso solo dev 10k MRR |
| **App móvil de nicho (MAUI, ambas stores)** | ASO/communities (difícil, sin atajo) | Suscripción in-store (MoR resuelto) | Alta: shell MAUI ya compila; un código → iOS+Android | HabitKit: ~$600k/año solo dev ([breakdown](https://www.buildmvpfast.com/blog/602k-revenue-solo-indie-hacker-app-portfolio-breakdown-2026)) |
| **Devtools / VS Code extension de nicho** | Marketplace gratis | Manual: license keys vía LS | Alta: ya construyó extensión (OpenCode sidebar) | Claim $6.8k/mes ([dev.to](https://dev.to/hopkins_jesse_cdb68cfa22c/how-i-make-6800month-selling-niche-vs-code-extensions-eji) ⚠️ posible promocional); VS Code **no tiene billing nativo** ([issue #111800](https://github.com/microsoft/vscode/issues/111800)) |
| Micro-SaaS SEO-driven clásico | SEO/content propio (lento con 10h) | LS | Media | Mediana solo-dev SaaS: ~$1.7k MRR ([agregados](https://bigideasdb.com/solo-developer-saas-monthly-revenue-examples)) |

**Lectura:** en global la expectativa realista es mediana ~$1.7-2k MRR (≈ gran ingreso extra en ARS) y techo de reemplazo de sueldo en $5-15k MRR tras años. Restricción heredada: nada salud (no-compete aplica igual en global).

### Comparación con datos (ronda 2, 29/10)

**Shopify App Store** ([estadísticas 2026](https://www.adsx.com/blog/shopify-app-store-statistics-2026)):
- 21.5-24k apps; 2.713 lanzamientos/mes vs 56 remociones — catálogo inflándose; distribución es la restricción, no construir.
- **Revenue share 0% del primer USD 1M lifetime** (luego 15% + 2.9% procesamiento, USD 19 una vez) — mejor que Lemon Squeezy (5%).
- Categorías top-10 saturadas (Analytics 982 apps…). Brechas estructurales: nichos operativos aburridos; **76.6% de las apps son solo en inglés** (latino/hispano/BR = campo más fino); badge Built for Shopify solo 7% del catálogo.

**Apps móviles suscripción** ([RevenueCat vía Steal What Works](https://stealwhatworks.com/blogs/news/mobile-apps-over-10k-month-now)):
- Solo **4.6% de apps nuevas alcanza $10k/mes en 2 años** (17.3% llega a $1k). Lanzamientos: 2k→14.7k/mes en 4 años — odds por app empeorando.
- Hit rates por categoría: Gaming 8.9%, Photo&Video 7.3%, Business 1.6%. Ganadores: apps de una frase (Snag ~$30k, Momego ~$30k solo-dev tránsito, ElevenStoic $20k+). 500-2.000 suscriptores pagan bastan. Dos rutas: UGC/paid o ASO + landing pages localizadas.
- ⚠️ iOS = 77% de lanzamientos y mejores economías → para MAUI hace falta Mac (local o CI) para compilar iOS.

**Devtools/extensiones**: sin billing nativo en VS Code; Cursor usa Open VSX (publicar doble, riesgo ToS). Rieles de cobro artesanales (LS license keys). Claim $6.8k/mes sin verificar. **Arquetipo más débil de los tres como motor de negocio.**

**Veredicto comparado para este perfil (<10h, 1 persona, .NET, MAUI disponible):**

| # | Arquetipo | Por qué |
|---|---|---|
| 1 | **App Shopify en nicho operativo no-anglosajón** | 0% share <$1M, distribución comprada, brecha de localización medible, backend .NET viable |
| 2 | App móvil MAUI de nicho | Mayor varianza (4.6% odds), techo alto; requiere Mac para iOS y skill de UGC/ASO; segundo producto, no el primero |
| 3 | Devtools | Rieles flojos; experimento, no negocio |

## 9. Pendientes de investigación

- [x] **SHT: deep dive** — resultado: competencia detectada (Inditia Safe). Hipótesis de nicho vacío descartada.
- [x] Analizar brechas de Inditia Safe — hecho: precio público y self-serve cierran el vertical (ver atlas #1)
- [x] Logística/fletes — hecho (atlas #11): fisura técnica con mala economía
- [ ] Conteo manual de jardines y consultoras SHT en los 4 partidos (Google Maps/habilitaciones municipales)
- [ ] Verificar cláusula exacta del contrato con Alephoo
- [ ] Validación con humanos: internet no puede confirmar disposición a pagar

## 10. Riesgos del método

Toda la densidad de competencia está medida con fuentes; la **demanda no**. Que no exista SaaS para SHT puede significar fisura real o que nadie paga. La única forma de cerrarlo: 10 conversaciones de preventa cuando llegue el momento (hoy el usuario pidió no contactar todavía).
