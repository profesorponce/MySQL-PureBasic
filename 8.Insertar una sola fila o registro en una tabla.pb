;-----------------------------------------------------------------------
; Insertar datos en una tabla en una base de datos MySQL en PureBasic
; (c) 2023 por Ricardo Ponce
; https://profesorponce.blogspot.com/
;-----------------------------------------------------------------------

; Base de datos
; -------------------------------------------------------
; Nombre = JavaBDD
; Usuario = root (password =no)
; 
; Tabla   = usuarios
; 
;           Nombre      tipo      tamaño  autoincremental
;           ----------  --------  ------  ---------------
; Campo 1 = id          int                    si 
; Campo 2 = Nombre      varchar   50           no 
; Campo 3 = Correo      varchar   30           no
; Campo 4 = Oficina     varchar   20           no
; -------------------------------------------------------

; En este ejemplo, verá que los datos a insertar se ingresan en un Array, pero el método de ingreso
; puede ser a través de un Frame con campos y cuando se presione el botón grabar. 
; El método de ingrearlos en un Array es para facilitar medianamente el ingreso de datos semi-masivos.
; Observe que la sentencia INSERT se va componiendo a base de sumar cadenas de ordenes. 
; La sintaxis requerida por MySQL, igual que en SQL requiere que se ingresen comillas simples para 
; los valores de cadenas, (nombre, correo, oficina). La cadena INSERT se debería ver de este modo:
;
; INSERT INTO contacto (nombre, apellidos, telefono) VALUES ('Juan', 'Gomez', '123')
;
; En la linea de arriba se ven más claras las comillas simples para los datos que definimos como VARCHAR
; en nuestra tabla. Por eso en el código se puede ver que la formación de la cadena de órdenes para
; MySQL es del tipo ...VALUES ('"+nombres[i]+"','"...
;

  UseMySQLDatabase()

  ; Debe tener el server corriendo en localhost y tener la base de datos ya creada
  #DB_Id = 1
  DB_name$ = "javabdd"
  DB_usuario$="root"
  DB_password$=""
     
  ;-----------------------------------------------------------------------
  ;Establecer una conexion con una base de datos ya creada
  ;-----------------------------------------------------------------------
  If OpenDatabase(#DB_Id, "host=localhost port=3306 dbname="+ DB_name$, DB_usuario$, DB_password$)
    
     MessageRequester("MySQL", "Conectado a MySQL: "+DB_name$)
    
     ; Datos a ingresar en la tabla:
     ;
     ; Nombre   Email              Trabaja en
     ; -------  -----------------  --------------
     ; Juan     juan@gmail.com     administracion
     ; Pedro    pedro@yahoo.com    ventas
     ; Antonio  antonio@live.com   expediciones
     ; Laura    laura@hotmail.com  despacho
     ;
     ; Si se usa un array, los datos se puden grabar en un for-next enviando esta cdena de comandos:
     ;
     ; INSERT INTO usuarios(nombre, correo, funcion) VALUES ('"+nombre(i)+"','"+correo(i)+"','"+oficina(i)+"' )"    
     ;
     ; O se envia  un parametro simple por cada ficha de este modo:
     ;
     ; INSERT INTO usuarios (nombre, correo, oficina) VALUES ('Juan', 'juan@gmail.com', 'administracion')
     
     ;tabla en la que se ingresaran los datos
     DB_TableName$="usuarios"
     
     ;Insertar nuevamente a Laura
     DB_Command$ ="INSERT INTO usuarios (nombre, correo, oficina) VALUES ('Laura', 'laura@hotmail.com', 'despacho')"
     If DatabaseUpdate(#DB_Id, DB_Command$)
        MessageRequester("MySQL", "Laura insertada en la tabla")  
     Else   
        MessageRequester("MySQL", "Laura ya existe en la tabla")  
     EndIf
      
  Else
    MessageRequester("MySQL", "Falla en la conexión: "+DatabaseError())
  EndIf
    
  CloseDatabase (#DB_Id)
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 70
; FirstLine = 49
; EnableXP