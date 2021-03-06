package edu.tp2016.vista

import org.uqbar.arena.layout.VerticalLayout
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.PasswordField
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.ErrorsPanel
import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import edu.tp2016.applicationModel.UserLogin
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.windows.Dialog
import java.awt.Color
import org.uqbar.arena.bindings.ValueTransformer
import edu.tp2016.applicationModel.Buscador
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.CheckBox
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

class LoginWindow extends SimpleWindow<UserLogin> {
	
	new(WindowOwner parent) {
		super(parent, new UserLogin())
		title = "Login al sistema"
	}

	override createFormPanel(Panel mainPanel) {
		
		mainPanel.layout = new VerticalLayout
		new ErrorsPanel(mainPanel, "Ingrese usuario y contraseña")	
		
		new Panel(mainPanel) => [
			it.layout = new ColumnLayout(2)
			
			new Label(it).text = "Usuario:"
			new TextBox(it) => [
				value <=> "usuario"
				width = 110
			]
			
			new Label(it).text = "Contraseña:"
			new PasswordField(it) => [
				value <=> "password"
				width = 110
			]
		]
		
		new Panel(mainPanel) => [
			layout = new HorizontalLayout
			new Label(it).text = "Recordar cuenta: "
			new CheckBox(it).bindValueToProperty("recordar")
		]
		
		new Panel(mainPanel) => [
			it.layout = new ColumnLayout(3)
			
			new Button(it) => [
				caption = "Acceder"
				onClick [ |
					if (modelObject.validarLogin){
						openDialog(new BuscadorWindow(this, new Buscador(modelObject.usuarioLoggeado)))
						modelObject.salirLogin
					}
				]
				setAsDefault
				width = 100
			]
			new Button(it) => [ 
				caption = "Borrar"
				onClick [ | modelObject.limpiarLogin ]
				width = 100
			]
			new Button(it) => [ 
				caption = "Salir"
				onClick [ |this.close ]
				width = 100
			]
		]
		
		new Label(mainPanel) => [
 			(foreground <=> "resultadoLogin").transformer = new LoginOkTransformer 
 			value <=> "resultadoLogin"	
 		]
		
	}
	
	def openDialog(Dialog<?> dialog) {
		dialog.open
	}
	
	override protected addActions(Panel actionsPanel) {
		
	}
	
	
}

class LoginOkTransformer implements ValueTransformer<String, Object> {
 	
 	override getModelType() {
 		typeof(String)
 	}
 	
 	override getViewType() {
 		typeof(Object)
 	}
 	
 	override modelToView(String valorDelModelo) {
 		if(valorDelModelo.equalsIgnoreCase("<< Acceso exitoso >>")) Color.GREEN.darker
 			else Color.RED
 	}
 	
 	override viewToModel(Object valorDeLaVista) {
 		null	
 	}
}