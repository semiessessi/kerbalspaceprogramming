COPYPATH( "0:/lib/log", "1:/lib/log" ).

RUN ONCE "1:/lib/log".

PRINT( "===========================================" ).
PRINT( "              Autoboot v1.4.2              " ).
PRINT( "===========================================" ).

WAIT 1.

// allow for some time if physics is a knob to us
IF ( MISSIONTIME <= 10 )
{
    ML( "Mission has not commenced, starting bootstrap process..." ).

    WAIT 1.
    
    SET HEIGHT TO 80000.
    SET ANGLE TO 0.
    SET BOOTSTRAP TO "mercury".
    SET TEST_STRING TO SHIP:NAME:TOLOWER().
    
    IF( TEST_STRING:STARTSWITH( "mercury" ) )
    {
        SET BOOTSTRAP TO "mercury".
    }
    ELSE IF( TEST_STRING:STARTSWITH( "venus" ) )
    {
        SET BOOTSTRAP TO "venus".
    }
    
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
        ELSE IF( HEIGHT = 20000 )
        {
            SET HEIGHT TO 12500.
        }
        ELSE
        {
            SET HEIGHT TO HEIGHT - 10000.
        }
        
        IF( HEIGHT < 12500 )
        {
            SET HEIGHT TO 12500.
        }
        
        ML( "Target height set to: " + HEIGHT + "m" ).
        
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
        ELSE IF( HEIGHT = 12500 )
        {
            SET HEIGHT TO 20000.
        }
        ELSE
        {
            SET HEIGHT TO HEIGHT + 10000.
        }
        
        ML( "Target height set to: " + HEIGHT + "m" ).
        
        PRESERVE.
    }
    
    ON AG6
    {
        SET ANGLE TO ANGLE - 5.
        IF( ANGLE < 0 )
        {
            SET ANGLE TO 0.
        }
        
        ML( "Target inclination set to: " + ANGLE + " degrees" ).
        
        PRESERVE.
    }
    
    ON AG7
    {
        SET ANGLE TO ANGLE + 5.
        IF( ANGLE > 355 )
        {
            SET ANGLE TO 355.
        }
        
        ML( "Target inclination set to: " + ANGLE + " degrees" ).
        
        PRESERVE.
    }
    
    ON AG5
    {
        IF( BOOTSTRAP = "mercury" )
        {
            SET BOOTSTRAP TO "venus".
        }
        ELSE IF( BOOTSTRAP = "venus" )
        {
            SET BOOTSTRAP TO "mercury".
        }
        
        ML( "Bootstrapper set to " + BOOTSTRAP ).
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
