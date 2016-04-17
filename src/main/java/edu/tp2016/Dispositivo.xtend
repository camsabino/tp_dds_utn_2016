package edu.tp2016

import org.uqbar.geodds.Point
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import com.google.common.collect.Lists //Importada a través de una dependencia en el 'pom'.
import java.util.Arrays
import org.joda.time.LocalDateTime
import java.util.ArrayList

@Accessors
class Dispositivo {
	Point ubicacionActual
	LocalDateTime fechaActual
	List<POI> pois = new ArrayList<POI>
	Direccion direccion
	
	new(Point unaUbicacion, List<POI> listaPois, LocalDateTime unaFecha){
		ubicacionActual = unaUbicacion
		pois = listaPois
		fechaActual = unaFecha
	}
		
	def boolean consultarCercania(POI unPoi){		
		unPoi.estaCercaA(ubicacionActual)
	}
	
	def boolean consultarDisponibilidad(POI unPoi, String valorX){
		unPoi.estaDisponible(fechaActual,valorX)
	}
	
	def Iterable<POI> encontradosPorBusqueda(String texto){
		pois.filter [poi | !texto.equals("") && (poi.tienePalabraClave(texto) || poi.coincide(texto))]
	}
	
	def List<POI> buscar(String texto){
		Arrays.asList(Lists.newArrayList(this.encontradosPorBusqueda(texto)))
	}/* Dado que el filter retorna una colección de tipo ITERATOR, en este método se convierte la colección
	 * de ITERARTOR a ARRAYLIST, y finamente de ARRAYLIST a LIST, que es el tipo que usamos.
	 */
	
	
}