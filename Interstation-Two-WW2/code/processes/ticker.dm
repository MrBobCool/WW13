var/global/process/ticker/tickerProcess

/process/ticker
	var/lastTickerTimeDuration
	var/lastTickerTime
	var/playtime_elapsed = 0

/process/ticker/setup()
	name = "ticker process"
	schedule_interval = 20 // every 2 seconds

	lastTickerTime = world.timeofday

	if(!ticker)
		ticker = new

	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING, GAME_STATE_FINISHED)

	tickerProcess = src

	// what happens as soon as the server starts up
	spawn(0)
		if(ticker)
			ticker.pregame()
		start_serverswap_loop()
		start_serverdata_loop()

/process/ticker/fire()
	SCHECK
	var/currentTime = world.timeofday

	if(currentTime < lastTickerTime) // check for midnight rollover
		lastTickerTimeDuration = (currentTime - (lastTickerTime - TICKS_IN_DAY)) / TICKS_IN_SECOND
	else
		lastTickerTimeDuration = (currentTime - lastTickerTime) / TICKS_IN_SECOND

	lastTickerTime = currentTime

	ticker.process()

	// for keeping track of time - Kachnov
	if (list(GAME_STATE_PLAYING, GAME_STATE_FINISHED).Find(ticker.current_state))
		playtime_elapsed += schedule_interval

/process/ticker/proc/getLastTickerTimeDuration()
	return lastTickerTimeDuration
