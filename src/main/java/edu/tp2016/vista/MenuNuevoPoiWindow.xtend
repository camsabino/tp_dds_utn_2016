package edu.tp2016.vista

import org.uqbar.arena.windows.Dialog
import edu.tp2016.pois.POI
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import edu.tp2016.pois.Banco
import edu.tp2016.pois.ParadaDeColectivo
import edu.tp2016.pois.Comercio
import edu.tp2016.pois.CGP
import edu.tp2016.applicationModel.Buscador
import org.uqbar.arena.layout.ColumnLayout

class MenuNuevoPoiWindow extends Dialog<POI> {
	
	Buscador buscador
	
	new(WindowOwner owner, POI model, Buscador _buscador) {
		super(owner, model)
		buscador = _buscador
		this.delegate.errorViewer = this
		title = "Agregar nuevo POI"
	}
	
	override protected createFormPanel(Panel mainPanel) {
		new Panel(mainPanel) => [
			new Label(mainPanel)
				.text = ""
			new Button(mainPanel)
				.setCaption("Nuevo Banco")
				.onClick[ | openDialog(new NuevoBancoWindow(this, new Banco(), buscador)) ]
			
			new Button(mainPanel)
				.setCaption("Nuevo CGP")
				.onClick[ | openDialog(new NuevoCGPWindow(this, new CGP(), buscador)) ]
			
			new Button(mainPanel)
				.setCaption("Nuevo Comercio")
				.onClick[ | openDialog(new NuevoComercioWindow(this, new Comercio(), buscador)) ]
			
			new Button(mainPanel)
				.setCaption("Nueva Parada")
				.onClick[ | openDialog(new NuevaParadaWindow(this, new ParadaDeColectivo(), buscador)) ]
		
			new Label(mainPanel) => [ text = "" ]
			new Button(mainPanel)
				.setCaption("Salir")
				.onClick[ | this.cancel ]
		]
	}
	
	def openDialog(Dialog<?> dialog) {
		dialog.open
	}
}

class BajaPoiWindow extends Dialog<POI>{
	Buscador buscador
	
	new(WindowOwner owner, POI model, Buscador _buscador) {
		super(owner, model)
		buscador = _buscador
		this.delegate.errorViewer = this
		title = "Eliminar POI"
	}
	
	override protected createFormPanel(Panel mainPanel) {
		new Panel(mainPanel) => [
			new Label(mainPanel)
				.text = "¿Está seguro de que desesa eliminar este POI?"
	
			new Label(mainPanel) => [ text = "" ]
			new Panel(mainPanel)=> [
				it.layout = new ColumnLayout(2)
			new Button(it)
				.setCaption("Confirmar")
				.onClick[ | buscador.eliminarPoi(buscador.poiSeleccionado) this.accept ]
			new Button(it)
				.setCaption("Cancelar")
				.onClick[ | this.cancel ]
			]
		]
	}
}