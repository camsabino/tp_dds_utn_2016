package edu.tp2016.interfacesExternas.banco

import java.util.ArrayList
import java.util.List
import com.eclipsesource.json.JsonArray

class StubInterfazBanco implements InterfazBanco{
/**
	 * Búsqueda de Bancos mediante una interfaz externa. Genera una lista de SucursalBanco (objetos JSON).
	 * Dicha interfaz necesita como parámetro de búsqueda un String que represente el nombre del Banco,
	 * y devuelve todas las sucursales que cumplen con ese criterio.
	 * 
	 * @param nombreBanco cadena de texto que representa el nombre de un Banco
	 * @return lista de SucursalBanco
	 */
	override List<SucursalBanco> buscar(String nombreBanco) {
		val listaSucursalesEncontradas = new ArrayList<SucursalBanco>
		
		val sucursal1 = new SucursalBanco()
		sucursal1.add("banco", "Santander Rio")
		sucursal1.add("x", -34.9338322)
		sucursal1.add("y", 71.348353)
		sucursal1.add("sucursal", "Balvanera")
		sucursal1.add("gerente", "María Luna")
		
		val listaServicios = new JsonArray()
			listaServicios.add("cobro cheques")
			listaServicios.add("depósitos")
			listaServicios.add("extracciones")
			listaServicios.add("seguros")
			listaServicios.add("créditos")
			
			sucursal1.add("servicios", listaServicios)
		
			listaSucursalesEncontradas.add(sucursal1)
			// Y así con sucursal 2 y sucursal3, que se pueden copiar del enunciado (se hace un addAll)
			listaSucursalesEncontradas
}
}