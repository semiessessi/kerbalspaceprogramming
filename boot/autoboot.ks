COPYPATH( "0:/lib/log", "1:/lib/log" ).

RUN ONCE "1:/lib/log".

PRINT( "===========================================" ).
PRINT( "              Autoboot v1.2.1              " ).
PRINT( "===========================================" ).

WAIT 1.

IF ( MISSIONTIME <= 0 )
{
    ML( "Mission has not commenced, starting bootstrap process..." ).

    WAIT 1.
    
    SET HEIGHT TO 80000.
    SET ANGLE TO 0.
    SET BOOTSTRAP TO "mercury".
    // SHIP:NAME
    
    ML( "Press 5 to cycle bootstrapper." ).
    ML( "Press 6/7 to adjust target orbit inclination." ).
    ML( "Press 8/9 to adjust target orbit height." ).
    ML( "Press 0 to launch when happy with settings." ).
    
    SET DONE TO 0.
    
    ON AG10
    {
        SET DONE TO 1.
        
        ML( "Bootstrapper: " + BOOTSTRAP ).
        ML( "Height: " + HEIGHT ).
        ML( "Inclination: " + ANGLE ).
    }
    
    ON AG8
    {
        IF( HEIGHT >= 3000000 )
        {
            SET HEIGHT TO HEIGHT - 1000000.
        }
        ELSE IF( HEIGHT >= 300000 )
        {
            SET HEIGHT TO HEIGHT - 100000.
        }
        ELSE IF( HEIGHT = 80000 )
        {
            HEIGHT = 72500.
        }
        ELSE
        {
            SET HEIGHT TO HEIGHT - 10000.
        }
        
        IF( HEIGHT < 72500 )
        {
            SET HEIGHT TO 72500.
        }
        
        ML( "Target height set to :" + HEIGHT + "m" ).
        
        PRESERVE.
    }
    
    ON AG9
    {
        IF( HEIGHT >= 2000000 )
        {
            SET HEIGHT TO HEIGHT + 1000000.
        }
        ELSE IF( HEIGHT >= 200000 )
        {
            SET HEIGHT TO HEIGHT + 100000.
        }
        ELSE IF( HEIGHT = 72500 )
        {
            HEIGHT = 80000.
        }
        ELSE
        {
            SET HEIGHT TO HEIGHT + 10000.
        }
        
        ML( "Target height set to :" + HEIGHT + "m" ).
        
        PRESERVE.
    }
    
    ON AG6
    {
        SET ANGLE TO ANGLE - 5.
        IF( ANGLE < 0 )
        {
            SET ANGLE TO 0.
        }
        
        ML( "Target inclination set to :" + ANGLE + " degrees" ).
        
        PRESERVE.
    }
    
    ON AG7
    {
        SET ANGLE TO ANGLE + 5.
        IF( ANGLE > 355 )
        {
            SET ANGLE TO 355.
        }
        
        ML( "Target inclination set to :" + ANGLE + " degrees" ).
        
        PRESERVE.
    }
    
    WAIT UNTIL DONE > 0.
    
    COPYPATH( "0:/sys/" + BOOTSTRAP + "/bootstrap", "1:/sys/bootstrap" ).
    COPYPATH( "0:/sys/" + BOOTSTRAP + "/launch", "1:/sys/launch" ).
    COPYPATH( "0:/sys/" + BOOTSTRAP + "/idle", "1:/sys/idle" ).
    
    RUN "1:/sys/bootstrap".
    
    RUN "1:/sys/launch".
    
    LAUNCH( HEIGHT, ANGLE ).
}
ELSE
{
    RUN "1:/sys/idle".
}

SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
SET SHIP:CONTROL:NEUTRALIZE TO TRUE.
