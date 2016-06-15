package edu.tp2016.servidores

import java.util.HashMap
import edu.tp2016.observersBusqueda.Busqueda
import java.util.List
import edu.tp2016.pois.POI
import edu.tp2016.repositorio.Repositorio
import org.eclipse.xtend.lib.annotations.Accessors
import edu.tp2016.serviciosExternos.ExternalServiceAdapter
import java.util.ArrayList
import java.util.Date
import edu.tp2016.usuarios.Administrador
import edu.tp2016.usuarios.Terminal
import edu.tp2016.serviciosExternos.MailSender
import com.google.common.collect.Lists
import edu.tp2016.serviciosExternos.InactivePOI
import edu.tp2016.procesos.ResultadoDeProceso
import edu.tp2016.procesos.ResultadoDeDarDeBajaUnPoi

@Accessors
class ServidorCentral {

	List<ExternalServiceAdapter> interfacesExternas = new ArrayList<ExternalServiceAdapter>
	Repositorio repo = Repositorio.newInstance
	List<Terminal> terminales = new ArrayList<Terminal>
	List<Busqueda> busquedas = new ArrayList<Busqueda>
	List<Administrador> administradores = new ArrayList<Administrador>
	Administrador administrador // Para Entrega 3 (único administrador)
	MailSender mailSender
	List<ResultadoDeDarDeBajaUnPoi> poisDadosDeBaja = new ArrayList<ResultadoDeDarDeBajaUnPoi>

	

	new(List<POI> listaPois) {
		listaPois.forEach [ poi | repo.agregarPoi(poi)]
	}
	
	def agregarTerminales(List<Terminal> _terminales){
		_terminales.forEach [ terminal | terminal.servidorCentral = this ]
		terminales.addAll(_terminales)
	}
	
	def registrarPOI(POI poi){
		repo.agregarPoi(poi)
	}

	def void obtenerPoisDeInterfacesExternas(String texto, List<POI> poisBusqueda) {
		interfacesExternas.forEach [ unaInterfaz |
			poisBusqueda.addAll(unaInterfaz.buscar(texto))
		]
	}

// BÚSQUEDA EN EL REPOSITORIO:
	def Iterable<POI> buscarPor(String texto) {
		val poisBusqueda = new ArrayList<POI>
		poisBusqueda.addAll(repo.allInstances)

		obtenerPoisDeInterfacesExternas(texto, poisBusqueda)

		poisBusqueda.filter[poi|!texto.equals("") && (poi.tienePalabraClave(texto) || poi.coincide(texto))]
	}
	
	/**
	 * Devuelve el POI cuyo id se pasó como parámetro de búsqueda.
	 * Obs.: Busca en el repopsitorio de pois
	 * 
	 * @params id de un POI
	 * @return un POI
	 */
	def List<POI> buscarPorId(int _id) {
		val repoDePois = new ArrayList<POI>
		
		repoDePois.addAll(repo.allInstances)
		Lists.newArrayList( repoDePois.filter [poi | poi.id.equals(_id) ] )
	}
	
	def void registrarBusqueda(Busqueda unaBusqueda){
		busquedas.add(unaBusqueda)
	}

// REPORTES DE BÚSQUEDAS:
	/**
	 * Observación. Date es una fecha con el siguiente formato:
	 * public Date(int year, int month, int date)
	 * 
	 * @return reporte de búsquedas por fecha
	 */
	def generarReporteCantidadTotalDeBusquedasPorFecha() {
		val reporte = new HashMap<Date, Integer>()

		busquedas.forEach [ busqueda |

			val date = (busqueda.fecha).toDate

			if (reporte.containsKey(date)) {
				reporte.put(date, reporte.get(date) + 1)
			} else {
				reporte.put(date, 1)
			}
		]
		reporte
	}

	def generarReporteCantidadDeResultadosParcialesPorTerminal() {
		val reporte = new HashMap<String, List<Integer>>()

		busquedas.forEach [ busqueda |

			if (!reporte.containsKey(busqueda.nombreTerminal)) {
				reporte.put(busqueda.nombreTerminal, new ArrayList<Integer>)
			}
			reporte.get(busqueda.nombreTerminal).add(busqueda.cantidadDeResultados)
		]
		reporte
	}

	def generarReporteCantidadDeResultadosParcialesDeUnaTerminalEspecifica(String nombreDeConsulta) {
		val reporte = generarReporteCantidadDeResultadosParcialesPorTerminal().get(nombreDeConsulta)
		
		reporte
	}

	def generarReporteCantidadTotalDeResultadosPorTerminal() {
		val reporte = new HashMap<String, Integer>()

		busquedas.forEach [ busqueda |

			val cantResultados = busqueda.cantidadDeResultados

			if (reporte.containsKey(busqueda.nombreTerminal)) {
				val cantidadAcumulada = reporte.get(busqueda.nombreTerminal) + cantResultados

				reporte.put(busqueda.nombreTerminal, cantidadAcumulada)
			} else {
				reporte.put(busqueda.nombreTerminal, cantResultados)
			}
		]
		reporte
	}
	def void actualizaPOI (List<POI> POIS){
		POIS.forEach[unPoi| repo.update(unPoi) ]
	}
	def registrarResultadoDeBaja(ResultadoDeDarDeBajaUnPoi resultado){
		poisDadosDeBaja.add(resultado)
	}

}
