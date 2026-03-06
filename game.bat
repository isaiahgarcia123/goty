@echo off
setlocal EnableDelayedExpansion
title Knight RPG Expanded
color 0a

:: ===== PLAYER DATA =====
set name=Knight
set level=1
set xp=0
set nextxp=50
set maxhp=100
set hp=100
set gold=50
set potion=3
set sword=1

:: ===== MAIN MENU =====
:menu
cls
echo ============================
echo        KNIGHT RPG

echo ============================
echo Level: !level!   XP: !xp!/!nextxp!
echo HP: !hp!/!maxhp!
echo Gold: !gold!
echo Potions: !potion!
echo Sword Level: !sword!
echo.
echo 1 Explore
echo 2 Kingdom Shop
echo 3 Rest
echo 4 Inventory
echo 5 Save
echo 6 Load
echo 7 Quit

echo.
set choice=
set /p choice=Choose:

if "!choice!"=="1" goto explore
if "!choice!"=="2" goto shop
if "!choice!"=="3" goto rest
if "!choice!"=="4" goto inventory
if "!choice!"=="5" goto save
if "!choice!"=="6" goto load
if "!choice!"=="7" exit

goto menu

:: ===== REST =====
:rest
cls
echo You rest at the castle...
timeout /t 2 >nul
set hp=!maxhp!
echo HP restored!
pause
goto menu

:: ===== EXPLORE =====
:explore
cls

echo Exploring the wilderness...
timeout /t 2 >nul

:: Boss chance increases with level
set /a bosschance=5 + level*2
set /a roll=%random% %% 100

if !roll! LSS !bosschance! goto bossfight

set /a encounter=%random% %% 100

if !encounter! LSS 65 goto fight
if !encounter! GEQ 65 goto treasure

:: ===== TREASURE =====
:treasure
cls
set /a loot=(10 + %random% %% 30) + level*5

echo You found a treasure chest!
echo Gold found: !loot!
set /a gold+=loot
pause
goto menu

:: ===== NORMAL FIGHT =====
:fight
set /a enemyhp=30 + (level*10) + %random% %% 30
set /a enemydmg=5 + level*2 + %random% %% 8
set enemytype=Goblin

goto fightstart

:: ===== BOSS FIGHT =====
:bossfight
cls
echo A BOSS APPEARS!
timeout /t 1 >nul
set /a enemyhp=120 + level*30
set /a enemydmg=15 + level*5
set enemytype=Dragon

goto fightstart

:fightstart
:fightloop
cls
echo =====================
echo !enemytype! HP: !enemyhp!
echo Your HP: !hp!
echo =====================
echo 1 Attack
echo 2 Potion

echo 3 Defend

echo 4 Run

echo.

set action=
set /p action=Choose:

if "!action!"=="1" goto attack
if "!action!"=="2" goto potionuse
if "!action!"=="3" goto defend
if "!action!"=="4" goto run

goto fightloop

:attack
set /a damage=(10 * sword) + (level*2) + (%random% %% 6)
set /a enemyhp-=damage

echo You strike the enemy for !damage! damage!
timeout /t 1 >nul

if !enemyhp! LEQ 0 goto winfight

set /a hp-=enemydmg

echo Enemy hits you for !enemydmg!
timeout /t 1 >nul

if !hp! LEQ 0 goto gameover

goto fightloop

:defend
set /a block=2 + level + %random% %% 4
set /a hp-=block

echo You block most of the attack!
echo Damage taken: !block!
pause

if !hp! LEQ 0 goto gameover

goto fightloop

:potionuse
if !potion! LEQ 0 (
 echo No potions!
 pause
 goto fightloop
)

set /a potion-=1
set /a heal=30 + level*5
set /a hp+=heal

if !hp! GTR !maxhp! set hp=!maxhp!

echo You drink a potion and heal !heal! HP!
pause

goto fightloop

:run
set /a escape=%random% %% 100
if !escape! LSS 50 (
 echo You escaped!
 pause
 goto menu
)

echo Failed to escape!
pause

goto fightloop

:winfight

:: Rewards scale with level
set /a reward=(15 + %random% %% 20) + level*10
set /a xp_gain=(20 + %random% %% 15) + level*8

if "!enemytype!"=="Dragon" (
 set /a reward+=100
 set /a xp_gain+=80
)

echo Enemy defeated!
echo Gold gained: !reward!
echo XP gained: !xp_gain!

set /a gold+=reward
set /a xp+=xp_gain

pause

goto levelcheck

:: ===== LEVEL SYSTEM =====
:levelcheck
if !xp! GEQ !nextxp! (
 set /a level+=1
 set xp=0
 set /a nextxp+=60
 set /a maxhp+=25
 set hp=!maxhp!
 echo =====================
 echo       LEVEL UP!
 echo You are now level !level!
 echo Max HP increased!
 echo =====================
 pause
)

goto menu

:: ===== SHOP =====
:shop
cls

echo ========= KINGDOM SHOP =========
echo Gold: !gold!
echo.

echo 1 Buy Potion (20g)
echo 2 Iron Sword (100g)
echo 3 Steel Sword (250g)
echo 4 Knight Blade (500g)
echo 5 Leave

echo.

set shopchoice=
set /p shopchoice=Choose:

if "!shopchoice!"=="1" goto buy_potion
if "!shopchoice!"=="2" goto sword2
if "!shopchoice!"=="3" goto sword3
if "!shopchoice!"=="4" goto sword4
if "!shopchoice!"=="5" goto menu

goto shop

:buy_potion
if !gold! LSS 20 (
 echo Not enough gold!
 pause
 goto shop
)

set /a gold-=20
set /a potion+=1

echo Potion purchased!
pause

goto shop

:sword2
if !gold! LSS 100 (
 echo Not enough gold!
 pause
 goto shop
)

set sword=2
set /a gold-=100

echo You bought an Iron Sword!
pause

goto shop

:sword3
if !gold! LSS 250 (
 echo Not enough gold!
 pause
 goto shop
)

set sword=3
set /a gold-=250

echo You bought a Steel Sword!
pause

goto shop

:sword4
if !gold! LSS 500 (
 echo Not enough gold!
 pause
 goto shop
)

set sword=5
set /a gold-=500

echo You bought the Knight Blade!
pause

goto shop

:: ===== INVENTORY =====
:inventory
cls

echo ===== INVENTORY =====
echo Level: !level!
echo HP: !hp!/!maxhp!
echo Gold: !gold!
echo Potions: !potion!
echo Sword Level: !sword!
echo =====================

pause
goto menu

:: ===== SAVE =====
:save
(
 echo set level=!level!
 echo set xp=!xp!
 echo set nextxp=!nextxp!
 echo set maxhp=!maxhp!
 echo set hp=!hp!
 echo set gold=!gold!
 echo set potion=!potion!
 echo set sword=!sword!
) > savegame.bat

echo Game Saved!
pause

goto menu

:: ===== LOAD =====
:load
if not exist savegame.bat (
 echo No save file found!
 pause
 goto menu
)

call savegame.bat

echo Game Loaded!
pause

goto menu

:: ===== GAME OVER =====
:gameover
cls

echo ===================
echo      GAME OVER

echo ===================
pause
exit
