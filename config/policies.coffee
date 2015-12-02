module.exports = 
	policies:		
		WebServerController:
			'*':		false
			find:		['isAuth', 'filterByOwner']
			findOne:	['isAuth', 'filterByOwner']
			create:		['isAuth', 'setOwner']
			update:		['isAuth', 'isOwner']
			destroy:	['isAuth', 'isOwner']
		ResLogController:
			'*':		false
			find:		['isAuth', 'filterByOwner', 'reslog/orderByDateDesc']