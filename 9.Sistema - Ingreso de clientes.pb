
﻿;-----------------------------------------------------------------------
; SISTEMA - Ingreso de clientes en una tabla en una base de datos MySQL
;           en PureBasic
; (c) 2023 por Ricardo Ponce
; https://profesorponce.blogspot.com/
;-----------------------------------------------------------------------

; Base de datos
; -------------------------------------------------------
; Nombre = JavaBDD
; Usuario = root (password =no)
; 
; Tabla   = clientes
; 
;           Nombre      tipo      tamaño  autoincremental
;           ----------  --------  ------  ---------------
; Campo 1 = id          int                    si 
; Campo 2 = Nombre      varchar   50           no 
; Campo 3 = Apellido    varchar   30           no
; Campo 4 = Telefono    varchar   20           no
; -------------------------------------------------------

; En este ejemplo, verá ccomo se implementa un programa completo con su interfaz grafica
; para poder ingresar datos a una talba en una Base De Datos MySQL
; El programa permite ingresar datos de un cliente (Nombre, Apellido y Teléfono) en una
; tabla (clientes) de la base de datos JavaBDD.
;
; Para el ejemplo de este programa, la table CLIENTES ya debe estar creada. Pero puede 
; usar el programa 2 (2.Insertar una tabla.pb) para crearla
;
; Al iniciar el programa, usted podra ingresar los datos a un form visual. Al presionar
; el botón GRABAR, el programa lee los datos ingresadoa a un formulario y llama a un 
; procedimiento que verifica si el cliente ya esta ingresado previamente.
;
; 1) Si el cliente ya esta ingresado, el programa no grabara la ficha
; 2) Si el cliente NO ESTA INGRESADO, el programa grabara la ficha nueva dentro de la tabla
;

; enumeración de las variables GLOBALES para identificación de los
; controles de la interface visual. En las enumeraciones PureBasic
; genera los numeros automticamente sin ser necesario que el 
; programador los defina
Enumeration FormMenu
  #Ventana_Principal  ; ID del form o ventana principal
  #BOTON_GRABAR       ; ID del boton grabar
  #APELLIDO           ; ID del textbox para ingreso del apellido
  #NOMBRE             ; ID del textbox para ingreso del nombre
  #TELEFONO           ; ID del textbox para ingreso del telefono
EndEnumeration

Global EstaDuplicado.l = 0 ; Variable EstaDuplicado del tipo long (.l)
                           ; En este programa la variable EstaDuplicado puede adquirir 3 posibles
                           ; valores:
                           ; Valor cero (0) = NO - El cliente NO ESTA DUPLICADO y el programa puede
                           ;                  proceder a grabar la ficha
                           ; Valor cero (1) = SI - El cliente YA ESTA GRABADOSTA y el programa 
                           ;                  NO GRABARA LA FICHA ingresada
                           ; Valor cero (2) = ERROR - Se produjo un error de conexión entre el
                           ;                  programa y la base de datos y el uusuario debe
                           ;                  verificar la conexión a internet 

; ----------------------------------------------------------------
; Procedimiento GrabarFicha en la tabla CLIENTES de la BDD JavaBDD
; ----------------------------------------------------------------
Procedure.l GrabarFicha (nombre$,apellido$,telefono$)
  
  ; este procedimiento procede a grabar los datos de la ficha del cliente
  ; en la tabla CLIENTES de la base de datos JavaBDD
  ; el programa llega acá solamente cuando el sistema ha verificado que la
  ; ficha no existe previamente
  
  ; esta funcion devuelve 3 estados posibles:
  ; 0 = NO SE PUDO GRABAR
  ; 1 = SI SE PUDO GRABAR
  ; 2 = ERROR en la conexión entre Programa y Base de datos
  
  Segrabo.l=0 ;NO - por defecto, esta variable es inicializada como NO SE GRABO
    
  #DB_Id = 1
  DB_name$ = "JavaBDD"
  DB_usuario$="root"
  DB_password$=""
  
  UseMySQLDatabase()
  
  If OpenDatabase(#DB_Id, "host=localhost port=3306 dbname="+ DB_name$, DB_usuario$, DB_password$)
     DB_Command$ ="INSERT INTO clientes (apellido, nombre, telefono) VALUES ('"+apellido$+"', '"+nombre$+"', '"+telefono$+"')"
     If DatabaseUpdate(#DB_Id, DB_Command$)
        Segrabo =1 ;si se pudo grabar 
     Else   
        Segrabo =0 ;no se grabaron datos  
     EndIf
  Else
    Segrabo =2;error en grabacion
  EndIf
    
  CloseDatabase (#DB_Id)
  
  ProcedureReturn Segrabo ;RETORNA EL ESTADO DE GRABACION
  
EndProcedure

; ----------------------------------------------------------------
; Procedimiento VerificarSiEstaGrabado
; ----------------------------------------------------------------
Procedure.l VerificarSiEstaGrabado(apellido$)
  
  ; este procedimiento Vverifica si un cliente ya esta grabado en el sistema
  ; dentro de la tabla CLIENTES de la base de datos JavaBDD
  ; el programa llega acá cuando el usuario presiona el boton GRABAR
    
  ; esta funcion devuelve 3 estados posibles:
  ; 0 = NO ESTA GRABADO 
  ; 1 = SI ESTA GRABADO
  ; 2 = ERROR en la conexión entre Programa y Base de datos

  #DB_Id = 1
  DB_name$ = "JavaBDD"
  DB_usuario$="root"
  DB_password$=""
  
  UseMySQLDatabase()
  
  If OpenDatabase(#DB_Id, "host=localhost port=3306 dbname="+ DB_name$, DB_usuario$, DB_password$)
         
     DB_Command$ ="SELECT * FROM clientes WHERE Apellido='"+apellido$+"'"    
     
     If DatabaseQuery(#DB_Id,  DB_Command$) ; Genera el RecordSet de la tabla 'usuarios'

        EstaDuplicado = 0 ;inicialización con el estado= no esta duplicado
       
        DB_Columna = 1 ;se programa para ver la columna 'nombre'
       
        While NextDatabaseRow(#DB_Id)                  
          If apellido$=GetDatabaseString(#DB_Id, DB_Columna) ;verifica si el apellido esta grabado
            EstaDuplicado = 1 ;si esta grabado
          EndIf  
        Wend                                          
        FinishDatabaseQuery(#DB_Id) ; fin de la consulta
        
     EndIf
   Else
     EstaDuplicado = 2 ;error de conexion con bdd
   EndIf
   
  CloseDatabase (#DB_Id)
  ProcedureReturn EstaDuplicado ;RETORNA SI ESTA GRABADO (SI-NO) O ERROR DE CONEXION
  
EndProcedure

; -----------------------------
; inicio del programa principal
; -----------------------------

; Flags de configuración para la ventana principal usado en OpenWindow
#FLAGS =  #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget

  OpenWindow(#Ventana_Principal, x, y, 450, 300, "Ingreso de clientes", #FLAGS) ; form o ventana principal
  TextGadget(#PB_Any, 40, 40, 140, 25, "Ingese el Apellido")      ;label
  TextGadget(#PB_Any, 40, 100, 130, 20, "Ingrese el nombre")      ;label
  TextGadget(#PB_Any, 40, 170, 140, 25, "Ingrese el telefono")    ;label
  ButtonGadget(#BOTON_GRABAR, 290, 220, 100, 25, "Grabar")        ;botón
  StringGadget(#APELLIDO, 230, 40, 170, 20, "apellido aqui...")   ;textbox apellido del cliente
  StringGadget(#NOMBRE, 230, 100, 170, 20, "nombre aqui,,,")      ;textbox nombre del cliente
  StringGadget(#TELEFONO, 230, 160, 170, 20, "telefono aqui...")  ;textbox telefono del cliente 
  
  
 Repeat
           
   Event.l = WaitWindowEvent()
  
   Select Event
      Case #PB_Event_ActivateWindow ; activacion de ventana
      Case #PB_Event_DeactivateWindow ; desactiva la ventana  
      Case #PB_Event_MinimizeWindow   ; minimizacion de ventana
      Case #PB_Event_MaximizeWindow; maximizacion de ventana
      Case #PB_Event_MoveWindow  ;mover ventana
      Case #PB_Event_CloseWindow ;close windows
      Case #PB_Event_LeftClick ;click izquierdo raton
      Case #PB_Event_LeftDoubleClick ; doble click izquierdo raton
      Case #PB_Event_RightClick ;click derecho raton
            
      Case #PB_Event_Menu
     
      Case #PB_Event_Gadget 
            Select EventGadget() ;
               Case #BOTON_GRABAR
                  Data_Apellido$ = GetGadgetText(#APELLIDO) ;extrae el apellido del textbox
                  Data_Nombre$ = GetGadgetText(#NOMBRE) ;extrae el nombre del textbox
                  Data_Telefono$ = GetGadgetText(#TELEFONO) ;extrae el telefono del textbox
                  
                  ; llamadaal proceso de verificación para saber si la ficha ya esta grabada
                  Select VerificarSiEstaGrabado(Data_Apellido$)
                      Case 1  ;esta duplicado (no se grabara)
                        ; si ya esta grabado el sistema no grabara la ficha
                        MessageRequester("DUPLICADO", "El cliente ya esta grabado") 
                      Case 2  ;error de conexion (intentar de nuevo)
                        ; la conexión esta inestable, el programa no pudo conectar
                        MessageRequester("SIN CONEXION", "Verifique internet y vuelva a intentar") 
                      Default ;llamar a la grabacion
                        ; el programa llega aca si la ficha no esta grabada
                        If GrabarFicha (Data_Nombre$,Data_Apellido$,Data_Telefono$)
                          ; si se pudo grabar, retorna un aviso para avisar que termino bien
                          MessageRequester("GRABADO", "Se grabo la ficha") 
                        Else
                          ; si no pudo grabar el programa le avisa al usuario
                          MessageRequester("NO SE GRABO", "El sistema no pudo grabar la ficha") 
                        EndIf  
                  EndSelect

            EndSelect ;EventGadget
      Default      
   EndSelect ;Event
              
 Until Event = #PB_Event_CloseWindow Or Quit = #True
 
 End


; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 219
; FirstLine = 192
; Folding = -
; EnableXP