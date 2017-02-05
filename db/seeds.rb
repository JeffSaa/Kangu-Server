UserType.create(name: "Supervisor") 		#1

UserType.create(name: "FrepiAdmin")			#2

UserType.create(name: "FrepiMan")			#3

UserType.create(name: "FrepiShopper")		#4

UserType.create(name: "BusinessOwner", can_login_app_business: true, can_create_business_place: true, can_create_business_sucursal: true,
	can_admin_business_places: true, can_admin_business_sucursal: true, can_create_sucursal_order: true, cand_admin_business_orders: true,
	can_see_business_stats: true, can_see_sucursal_stats: true,
	can_login_app_home: true, can_create_home_order: true,
	can_)									#5

UserType.create(name: "BusinessAdmin")		#6

UserType.create(name: "BusinessOperator")	#7

UserType.create(name: "HomeUser")			#8

UserType.create(name: "Developer")			#9