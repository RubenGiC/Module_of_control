;;;; Autor: Ruben Girela Castellon ;;;
;;;; En principio las propiedades que usaria son: ;;;;

;;;; - Le pregunta si le gusta o no el hardware y dependiendo de su respuesta le hago otras preguntas: ;;;;
;;;; 	· Si no le gusta el hardware (le pregunto si le gusta programar (toma los valores: SI o NO)) ;;;;
;;;; 	· Si le gusta el hardware (le pregunto si le gusta las matematicas (toma los valores: SI o NO)) ;;;;

;;;; - Dependiendo si le gusta o no programar le pregunto: ;;;;
;;;; 	· Si no le gusta programar (le pregunto la nota) ;;;;
;;;; 	· Si le gusta programar (le pregunto si le gusta las matematicas (toma los valores: SI o NO)) ;;;;

;;;; - Preguntar la nota media (toma un valor numerico con decimales o entero);;;;
;;;; - Dependiendo de la nota hara unas preguntas u otras: ;;;;
;;;; 	· Si la nota es baja (le preguntare si quiere trabajar en la docencia, empresa publica o en una empresa privada (toma los valores: DOCENCIA, PUBLICA o PRIVADA)) ;;;;
;;;; 	· Si la nota es media o alta (le pregunto si le gusta las matematicas (toma los valores: SI o NO)) ;;;;

;;;; - Dependiendo si le gusta las matematicas o no le preguntare: ;;;;
;;;; 	· Si no le gusta las matematicas (le pregunto si quiere trabajar mucho, normal o poco (toma los valores: MUCHO, NORMAL o POCO)) ;;;;
;;;; 	· Si le gusta las matematicas (le pregunto si le gusta programar (toma los valores: SI o NO)) ;;;;


;;;; - Dependiendo del esfuerzo que quiera trabajar, le preguntare: ;;;;
;;;; 	· Mucho o normal (le pregunto si le gusta el hardware (toma los valores: SI o NO)) ;;;;
;;;;	· poco (le pregunto si quiere trabajar en la docencia, empresa publica o en una empresa privada (toma los valores: DOCENCIA, PUBLICA o PRIVADA)) ;;;;

;;;; - Dependiendo donde quiere trabajar, le preguntare: ;;;;
;;;; 	· docencia (le pregunto si le gusta la teoria o practica (toma los valores: TEORIA, PRACTICA, AMBAS o NOLOSE)) ;;;;


;;;; Esto puede parecer un bucle infinito, en algunos casos, pero comprueba antes si ha hecho esa pregunta antes ;;;;
;;;; Con la información obtenida de esas preguntas obtiene una conclusión ;;;;


;;; crea las ramas para los hechos ;;;
(deffacts Ramas
(Rama Computacion_y_Sistemas_Inteligentes)
(Rama Ingenieria_del_Software)
(Rama Ingenieria_de_Computadores)
(Rama Sistemas_de_Informacion)
(Rama Tecnologias_de_la_Informacion)
)



;;; Inicializo los valores a vacio ;;;
(defrule valores_default
=>
(assert (like_mat DESCONOCIDO))
(assert (like_hardware DESCONOCIDO))
(assert (like_programming DESCONOCIDO))
(assert (trabajar DESCONOCIDO))
(assert (prefiere_t_p DESCONOCIDO))
(assert (like_work DESCONOCIDO))
(assert (explicacion_csi DESCONOCIDO))
(assert (explicacion_is DESCONOCIDO))
(assert (explicacion_ic DESCONOCIDO))
(assert (explicacion_si DESCONOCIDO))
(assert (explicacion_ti DESCONOCIDO))
(assert (Deduccion_nota_media DESCONOCIDO))
(assert (Conclusion DESCONOCIDO DESCONOCIDO))
)

;;; Le da la bienvenida al usuario ;;;
(defrule bienvenida
(declare (salience 9999))
=>
(printout t "Bienvenido al Sistema Experto Simple de Ruben Girela" crlf)
)


;;; deduce si la nota media es baja ;;;
(defrule deduce_nota_baja
	?f <- (Nota_media ?n)
	?g <- (Deduccion_nota_media)
	(test (< ?n 7))
=>
(retract ?f)
(retract ?g)
(assert (Deduccion_nota_media BAJA))
)
;;; deduce si la nota es media ;;;
(defrule deduce_nota_media
	?f <- (Nota_media ?n)
	?g <- (Deduccion_nota_media)
	(test (and (>= ?n 7) (< ?n 9)))
=>
(retract ?f)
(retract ?g)
(assert (Deduccion_nota_media MEDIA))
)
;;; deduce si la nota es alta ;;;
(defrule deduce_nota_alta
	?f <- (Nota_media ?n)
	?g <- (Deduccion_nota_media)
	(test (>= ?n 9))
=>
(retract ?f)
(retract ?g)
(assert (Deduccion_nota_media ALTA))
)


;;; Pregunta la nota media que tiene ;;;
(defrule pregunta_nota_media
?f <- (preguntar_nota ?x)
(like_programming ?prog)
(test (eq ?x SI))
(test (or (eq ?prog NO) (eq ?prog NOLOSE)))
=>
(retract ?f)
(printout t "Cual es tu nota media? ")
(assert (Nota_media (read)))

)


;;; comprobadores de que los datos sean correctos ;;;
(defrule comprobar_nota
?f <- (Nota_media ?n)
(test (or (> ?n 10) (< ?n 0)))
=>
(printout t "Hey la nota tiene que estar entre 0 y 10, no me hagas trampas ;)" crlf)
(retract ?f)
(assert (preguntar_nota SI))
)

;;; imprime por pantalla el consejo que ha concluido ;;;
(defrule conclusion
(declare (salience 999))
(Consejo ?X ?Y ?Z) ;;X --> nombre de la rama, Y --> explicación, Z --> mi nombre ;;

=>
(printout t "El experto " ?Z " le recomienda escoger la rama " ?X ", " ?Y   crlf)
)


;;; Pregunta si le gusta las matematicas ;;;
(defrule pregunta_matematicas
(like_hardware ?y)
(like_programming ?prog)
(Deduccion_nota_media ?nota)
?f <- (like_mat ?m)
(test (or (neq ?y DESCONOCIDO) (eq ?y NOLOSE) (eq ?prog SI) (eq ?nota ALTA) (eq ?nota MEDIA)))
(test (eq ?m DESCONOCIDO))
=>
(retract ?f)
(printout t "Te gusta las matematicas? (SI, NO o NOLOSE) ")
(assert (like_mat (read)))

)


;;; Pregunta si le gusta el hardware ;;;
(defrule pregunta_hardware
(trabajar ?z)
?f <- (like_hardware ?m)

(test (eq ?m DESCONOCIDO))
(test (or (eq ?m DESCONOCIDO) (eq ?z MUCHO) (eq ?z NORMAL)))
=>
(retract ?f)
(printout t "Te gusta el hardware? (SI, NO o NOLOSE) ")
(assert (like_hardware (read)))

)

;;; Pregunta si le gusta programar ;;;
(defrule pregunta_programar
(like_mat ?x)
(like_hardware ?y)
?f <- (like_programming ?m)
(test (or (eq ?x SI) (neq ?y DESCONOCIDO) (eq ?x NOLOSE) (eq ?y NOLOSE)))
(test (eq ?m DESCONOCIDO))
=>
(retract ?f)
(printout t "Te gusta programar? (SI, NO o NOLOSE) ")
(assert (like_programming (read)))

)


;;; Pregunta si quiere trabajar mucho o poco ;;;
(defrule pregunta_trabajar
(like_mat ?x)

?f <- (trabajar ?m)
(test (or (eq ?x NO) (eq ?x NOLOSE)))
(test (eq ?m DESCONOCIDO))
=>
(retract ?f)
(printout t "Como quieres trabajar? (MUCHO, NORMAL, POCO o NOLOSE) ")
(assert (trabajar (read)))

)


;;; Pregunta si PREFIERE TEORIA O PRACTICA ;;;
(defrule pregunta_teoria_practica
(like_work ?x)
(like_hardware ?hard)

?f <- (prefiere_t_p ?m)
(test (or (eq ?x DOCENCIA) (eq ?hard NO)))
(test (eq ?m DESCONOCIDO))
=>
(retract ?f)
(printout t "Te gusta mas la teoria o practica? (TEORIA, PRACTICA, AMBAS o NOLOSE) ")
(assert (prefiere_t_p (read)))

)


;;; Pregunta si quiere trabajar en la docencia, empresa publica o privada ;;;
(defrule pregunta_donde_trabajar

(trabajar ?work)
(prefiere_t_p ?tp)
(Deduccion_nota_media ?nmedia)

?f <- (like_work ?m)
(test (or (eq ?work POCO) (eq ?tp PRACTICA) (eq ?tp AMBAS) (eq ?nmedia BAJA)))
(test (eq ?m DESCONOCIDO))
=>
(retract ?f)
(printout t "Donde te gustaria trabajar en la docencia, empresa publica o privada? (DOCENCIA, PUBLICA, PRIVADA o NOLOSE) ")
(assert (like_work (read)))

)


;;; el sistema expone el porque de la elección de la rama CSI ;;;
;;; si le gusta las matematicas o no ;;;
(defrule porque_csi_matematicas_si
(like_mat ?matematicas)
(test (eq ?matematicas SI))
=>
(assert (porque_csi "te gusta las matematicas, "))
)
;;; no le gusta el hardware ;;;
(defrule porque_csi_hardware_no
(like_hardware ?hardware)
(test (eq ?hardware NO))
=>
(assert (porque_csi "no te gusta el hardware, "))
)
;;; si le gusta programar o no
(defrule porque_csi_programar_si
(like_programming ?prog)
(test (eq ?prog SI))
=>
(assert (porque_csi "te gusta programar, "))
)
;;; si le gusta la teoria ;;;
(defrule porque_csi_teoria
(prefiere_t_p ?t)
(test (eq ?t TEORIA))
=>
(assert (porque_csi "te gusta la teoria, "))
)
;;; si le gusta la teoria y practica ;;;
(defrule porque_csi_ambos
(prefiere_t_p ?t)
(test (eq ?t AMBAS))
=>
(assert (porque_csi "te gusta la teoria y practica, "))
)
;;;le gusta trabajar en la docencia ;;;
(defrule porque_csi_trabajar_docencia
(like_work ?t)
(test (eq ?t DOCENCIA))
=>
(assert (porque_csi "te gusta trabajar en la docencia, "))
)
;;;le gusta trabajar en una empresa privada ;;;
(defrule porque_csi_trabajar_privada
(like_work ?t)
(test (eq ?t PRIVADA))
=>
(assert (porque_csi "te gusta trabajar en una empresa privada, "))
)



;;; el sistema expone el porque de la elección de la rama IS ;;;
;;;no le gusta las matematicas
(defrule porque_is_matematicas_no
(like_mat ?matematicas)
(test (eq ?matematicas NO))
=>
(assert (porque_is "no te gusta las matematicas, "))
)
;;; no le gusta el hardware ;;;
(defrule porque_is_hardware_no
(like_hardware ?hardware)
(test (eq ?hardware NO))
=>
(assert (porque_is "no te gusta el hardware, "))
)
;;; si le gusta programar o no
(defrule porque_is_programar_si
(like_programming ?prog)
(test (eq ?prog SI))
=>
(assert (porque_is "te gusta programar, "))
)
;;;le gusta las practicas;;;
(defrule porque_is_practica
(prefiere_t_p ?t)
(test (eq ?t PRACTICA))
=>
(assert (porque_is "te gusta la practica, "))
)
;;;le gusta la teoria y la practica ;;;
(defrule porque_is_ambos
(prefiere_t_p ?t)
(test (eq ?t AMBAS))
=>
(assert (porque_is "te gusta la teoria y practica, "))
)
;;;le gusta trabajar en una empresa publica;;;
(defrule porque_is_publica
(like_work ?w)
(test (eq ?w PUBLICA))
=>
(assert (porque_is "te gusta trabajar en una empresa publica, "))
)
;;;le gusta trabajar en una empresa privada ;;;
(defrule porque_is_privada
(like_work ?w)
(test (eq ?w PRIVADA))
=>
(assert (porque_is "te gusta trabajar en una empresa privada, "))
)



;;; el sistema expone el porque de la elección de la rama IC ;;;
;;; le gusta el hardware;;;
(defrule porque_ic_hardware_si
(like_hardware ?hardware)
(test (eq ?hardware SI))
=>
(assert (porque_ic "te gusta el hardware, "))
)
;;;le gusta trabajar en una empresa publica;;;
(defrule porque_ic_publica
(like_work ?w)
(test (eq ?w PUBLICA))
=>
(assert (porque_ic "te gusta trabajar en una empresa publica, "))
)
;;;le gusta trabajar en una empresa privada ;;;
(defrule porque_ic_privada
(like_work ?w)
(test (eq ?w PRIVADA))
=>
(assert (porque_ic "te gusta trabajar en una empresa privada, "))
)
;;;le gusta las practicas;;;
(defrule porque_ic_practica
(prefiere_t_p ?t)
(test (eq ?t PRACTICA))
=>
(assert (porque_ic "te gusta la practica, "))
)
;;;le gusta la teoria y la practica ;;;
(defrule porque_ic_ambos
(prefiere_t_p ?t)
(test (eq ?t AMBAS))
=>
(assert (porque_ic "te gusta la teoria y practica, "))
)



;;; el sistema expone el porque de la elección de la rama SI ;;;
;;;le gusta trabajar poco;;;
(defrule porque_si_trabajar_poco
(trabajar ?t)
(test (eq ?t POCO))
=>
(assert (porque_si "te gusta trabajar poco, "))
)
;;;le gusta trabajar normal;;;
(defrule porque_si_trabajar_normal
(trabajar ?t)
(test (eq ?t NORMAL))
=>
(assert (porque_si "te gusta trabajar normal, "))
)
;;;le gusta las practicas;;;
(defrule porque_si_practica
(prefiere_t_p ?t)
(test (eq ?t PRACTICA))
=>
(assert (porque_si "te gusta la practica, "))
)
;;;le gusta la teoria y la practica ;;;
(defrule porque_si_ambos
(prefiere_t_p ?t)
(test (eq ?t AMBAS))
=>
(assert (porque_si "te gusta la teoria y practica, "))
)
;;; no le gusta el hardware ;;;
(defrule porque_si_hardware_no
(like_hardware ?hardware)
(test (eq ?hardware NO))
=>
(assert (porque_si "no te gusta el hardware, "))
)


;;; el sistema expone el porque de la elección de la rama TI ;;;
;;;no le gusta las matematicas
(defrule porque_ti_matematicas_no
(like_mat ?matematicas)
(test (eq ?matematicas NO))
=>
(assert (porque_ti "no te gusta las matematicas, "))
)
;;;le gusta trabajar poco;;;
(defrule porque_ti_trabajar_poco
(trabajar ?t)
(test (eq ?t POCO))
=>
(assert (porque_ti "te gusta trabajar poco, "))
)
;;;le gusta trabajar normal;;;
(defrule porque_ti_trabajar_normal
(trabajar ?t)
(test (eq ?t NORMAL))
=>
(assert (porque_ti "te gusta trabajar normal, "))
)



;;; el sistema genera una sola frase con el razonamiento deducido del porque ;;;
;;;para CSI;;;
(defrule genera_porques_csi
(declare (salience 999))
?f <- (porque_csi ?x)
?g <- (explicacion_csi ?y)
(test (eq ?y DESCONOCIDO))
=>
(assert (explicacion_csi (str-cat "Porque, " ?x)))
(retract ?f)
(retract ?g)
)
(defrule genera_porques_csi2
(declare (salience 999))
?f <- (porque_csi ?x)
?g <- (explicacion_csi ?y)
(test (neq ?y DESCONOCIDO))
=>
(assert (explicacion_csi (str-cat ?y ?x)))
(retract ?f)
(retract ?g)
)
;;;para IS;;;
(defrule genera_porques_is
(declare (salience 999))
?f <- (porque_is ?x)
?g <- (explicacion_is ?y)
(test (eq ?y DESCONOCIDO))
=>
(assert (explicacion_is (str-cat "Porque, " ?x)))
(retract ?f)
(retract ?g)
)
(defrule genera_porques_is2
(declare (salience 999))
?f <- (porque_is ?x)
?g <- (explicacion_is ?y)
(test (neq ?y DESCONOCIDO))
=>
(assert (explicacion_is (str-cat ?y ?x)))
(retract ?f)
(retract ?g)
)
;;;para IC;;;
(defrule genera_porques_ic
(declare (salience 999))
?f <- (porque_ic ?x)
?g <- (explicacion_ic ?y)
(test (eq ?y DESCONOCIDO))
=>
(assert (explicacion_ic (str-cat "Porque, " ?x)))
(retract ?f)
(retract ?g)
)
(defrule genera_porques_ic2
(declare (salience 999))
?f <- (porque_ic ?x)
?g <- (explicacion_ic ?y)
(test (neq ?y DESCONOCIDO))
=>
(assert (explicacion_ic (str-cat ?y ?x)))
(retract ?f)
(retract ?g)
)
;;;para SI;;;
(defrule genera_porques_si
(declare (salience 999))
?f <- (porque_si ?x)
?g <- (explicacion_si ?y)
(test (eq ?y DESCONOCIDO))
=>
(assert (explicacion_si (str-cat "Porque, " ?x)))
(retract ?f)
(retract ?g)
)
(defrule genera_porques_si2
(declare (salience 999))
?f <- (porque_si ?x)
?g <- (explicacion_si ?y)
(test (neq ?y DESCONOCIDO))
=>
(assert (explicacion_si (str-cat ?y ?x)))
(retract ?f)
(retract ?g)
)
;;;para TI;;;
(defrule genera_porques_ti
(declare (salience 999))
?f <- (porque_ti ?x)
?g <- (explicacion_ti ?y)
(test (eq ?y DESCONOCIDO))
=>
(assert (explicacion_ti (str-cat "Porque, " ?x)))
(retract ?f)
(retract ?g)
)
(defrule genera_porques_ti2
(declare (salience 999))
?f <- (porque_ti ?x)
?g <- (explicacion_ti ?y)
(test (neq ?y DESCONOCIDO))
=>
(assert (explicacion_ti (str-cat ?y ?x)))
(retract ?f)
(retract ?g)
)



;;;el sistema con los datos obtenidos razona para aconsejarle que rama elegir ;;;

;;;aconseja la rama CSI;;;
(defrule elegir_csi
(declare (salience -999))
(like_mat ?matematicas)
(like_programming ?programar)
(like_hardware ?hardware)
(like_work ?donde_trabajar)
(prefiere_t_p ?tp)
(explicacion_csi ?pq)

(test ( eq ?matematicas SI))
(test (or (eq ?hardware NO) (eq ?hardware NOLOSE)))
(test (or (eq ?programar SI) (eq ?programar NOLOSE)))
(test (or (eq ?donde_trabajar PUBLICA) (eq ?donde_trabajar NOLOSE) (eq ?donde_trabajar DESCONOCIDO)))
(test (neq ?tp PRACTICA))
=>
(assert (Conclusion Computacion_y_Sistemas_Inteligentes ?pq))
)


;;;aconseja la rama IS;;;
(defrule elegir_is
(declare (salience -999))
(like_mat ?matematicas)
(like_programming ?programar)
(like_hardware ?hardware)
(prefiere_t_p ?tp)
(like_work ?donde_trabajar)
(explicacion_is ?pq)

(test (or (eq ?matematicas NO) (eq ?matematicas NOLOSE) (eq ?matematicas DESCONOCIDO)))
(test (or (eq ?hardware NO) (eq ?hardware NOLOSE) (eq ?hardware DESCONOCIDO)))
(test (eq ?programar SI))
(test (or (eq ?tp PRACTICA) (eq ?tp AMBAS) (eq ?tp NOLOSE) (eq ?tp DESCONOCIDO)))
(test (or (eq ?donde_trabajar PRIVADA) (eq ?donde_trabajar PUBLICA) (eq ?donde_trabajar DESCONOCIDO) (eq ?donde_trabajar NOLOSE)))
=>
(assert (Conclusion Ingenieria_del_Software ?pq))
)


;;;aconseja la rama IC;;;
(defrule elegir_ic
(declare (salience -999))

(like_hardware ?hardware)
(like_work ?donde_trabajar)
(trabajar ?como_trabajar)
(prefiere_t_p ?tp)
(explicacion_ic ?pq)

(test (eq ?hardware SI))
(test (or (neq ?donde_trabajar DOCENCIA) (eq ?donde_trabajar NOLOSE) (eq ?donde_trabajar DESCONOCIDO)))
(test (or (eq ?tp PRACTICA) (eq ?tp AMBAS) (eq ?tp NOLOSE) (eq ?tp DESCONOCIDO)))
=>
(assert (Conclusion Ingenieria_de_Computadores ?pq))
)


;;;aconseja la rama SI;;;
(defrule elegir_si
(declare (salience -999))
(like_hardware ?hardware)
(prefiere_t_p ?tp)
(trabajar ?como_trabajar)
(explicacion_si ?pq)

(test (or (eq ?hardware NO) (eq ?hardware DESCONOCIDO)))
(test (or (eq ?tp PRACTICA) (eq ?tp AMBAS) (eq ?tp DESCONOCIDO) (eq ?tp NOLOSE)))
(test (or (eq ?como_trabajar POCO) (eq ?como_trabajar NORMAL) (eq ?como_trabajar NOLOSE) (eq ?como_trabajar DESCONOCIDO)))
=>
(assert (Conclusion Sistemas_de_Informacion ?pq))
)


;;;aconseja la rama TI;;;
(defrule elegir_ti
(declare (salience -999))
(like_hardware ?hardware)
(like_mat ?matematicas)
(prefiere_t_p ?tp)
(trabajar ?como_trabajar)
(explicacion_ti ?pq)

(test (or (eq ?matematicas NO) (eq ?matematicas NOLOSE)))
(test (or (eq ?como_trabajar POCO) (eq ?como_trabajar NORMAL) (eq ?como_trabajar NOLOSE) (eq ?como_trabajar DESCONOCIDO)))
=>
(assert (Conclusion Tecnologias_de_la_Informacion ?pq))
)


;;; imprimo la decisión que toma el sistema experto simple ;;;
(defrule aconsejar
	(Conclusion ?X ?Y)
	(Rama ?X)
	(test ( neq ?X DESCONOCIDO))
	(test (neq ?Y DESCONOCIDO))
=>
(assert (Consejo ?X ?Y "Ruben Girela"))
)

(defrule aconsejar2
	(Conclusion ?X ?Y)
	(Rama ?X)
	(test ( neq ?X DESCONOCIDO))
	(test (eq ?Y DESCONOCIDO))
=>
(assert (Consejo ?X "Porque no te decides, deberias decidirte ;)" "Ruben Girela"))
)

;;;;;;;;;Sistema 2;;;;;;;;;


(defmodule Sedu

	;;; Deftemplate de Consejo ;;;
	(deftemplate ConsejoEdu
		(field Rama)
		(field Explicacion)
		(field Experto))

	(export deftemplate Consejo))
	(defrule eligeCSI
	  (or (Mates SI) (Mates Nose))
	  (Prog SI)

	  =>
	  (assert (elegido Computacion_y_Sistemas_Inteligentes))
	)



	(defrule eligeTI
	  (Mates SI)
	  (Prog NO)
	  =>
	  (assert (elegido Tecnologias_de_la_Informacion))
	)

	(defrule eligeIS
	  (Mates NO)
	  (nota Baja)
	  =>
	  (assert (elegido Ingenieria_del_Software))
	)

	(defrule eligeIC
	  (Mates NO)
	  (or (nota Media) (nota Alta))
	  (Hardware SI)
	  =>
	  (assert (elegido Ingenieria_de_Computadores))
	)

	(defrule eligeSI
	  (Mates NO)
	  (or (nota Media) (nota Alta))
	  (Hardware NO)
	  =>
	  (assert (elegido Sistemas_de_Informacion))

	)


	(defrule Explicaciones1
	  (elegido ?c)
	  (Mates SI)
	  (Prog SI)
	  =>
	  (assert (Explicacion "te gustan las mates y la programacion"))
	)

	(defrule Explicaciones2
	  (elegido ?c)
	  (Mates SI)
	  (Prog NO)
	  =>
	  (assert (Explicacion "te gustan las mates pero no la programacion"))
	)

	(defrule Explicaciones3
	  (elegido ?c)
	  (Mates NO)
	  (nota Baja)
	  =>
	  (assert (Explicacion "no te gustan las mates y tienes la nota media baja"))
	)

	(defrule Explicaciones4
	  (elegido ?c)
	  (Mates NO)
	  (or (nota Media) (nota Alta))
	  (Hardware SI)
	  =>
	  (assert (Explicacion "no te gustan las mates, no tienes mala nota y ademas te gusta el Hardware"))
	)

	(defrule Explicaciones5
	  (elegido ?c)
	  (Mates NO)
	  (or (nota Media) (nota Alta))
	  (Hardware NO)
	  =>
	  (assert (Explicacion "no te gustan las mates, no tienes mala nota y ademas no te gusta el hardware"))
	)


	(defrule consejito
	  (elegido ?c)
	  (Explicacion ?y)
	  =>
	  (assert (Consejo (Rama ?c) (Explicacion ?y) (Experto Edu)))
	)

	(defrule imprimir
	  (Consejo (Rama ?c) (Explicacion ?y) (Experto ?x))
	  =>
	  (printout t "Hola, soy el experto " ?x crlf)
	  (printout t "Te recomiendo la rama " ?c crlf)
	  (printout t "Te la recomiendo porque " ?y crlf)
	)
