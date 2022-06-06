'=====
'Title: this is a program to forecast using Random Walk
'Author: Fadhilah Nur Binti Ismail
'Matric Number : A167808
'Date: 11th June 2020 (Thursday)
'=====

close @all
logmode l    'untuk bagi mesej kepada eviews

%path = @runpath 'untuk directkan path ke direktori
cd %path  'untuk tukar direktori path yang lain, so kat laptop org lain pon boleh run
%xlsdata = "es.xlsx"
%pathxlsdata = %path+%xlsdata

'==========
'Change file name here
%file = "Dila_RW"  'untuk namakan file 
'==========

'date will following US system
%dat_start ="2/1/2010" ' start data 1Feb 2010
%dat_end ="3/19/2020" 'end data 19 Mac 2020
%fcst_start ="3/20/2020" 'start forecasting 20 Mac 2020
%fcst_end ="9/30/2020" 'end forecasting 30 Sept 2020: end of third quarter 2020

 'create workfile, d5 ialah 5 hari seminggu
wfcreate(wf={%file}) d5 %dat_start %fcst_end
pagerename Untitled {%file}

string sheet1 = "data" 'namakan data sebab nama excel sheet tu ialah DATA

'import data,
'series 01 sebab takde nama atas colum date
for %a {sheet1}
import %pathxlsdata range=%a colhead=1 na="#N/A" @freq d5 @id @date(series01) @destid @date @smpl @all
next

logmsg done importing {%file}

'proses nak buat Exponential smoothing

%b ="usd"
freeze(stat{%b}) {%b}.stats
graph graph{%b}.line {%b}

series l{%b} = log({%b})
freeze(statl{%b}) l{%b}.stats 'nak dapatkan diskiptif statistik untuk log
graph graphl{%b}.line l{%b}

logmsg done descriptive statistic and graph {%file}

'==========
'Change here:

'Random Walk Model
smpl %dat_start %dat_end

'taip equation random walk
'ls adalah least square
'untuk estimate buatkan log
'c(1) adalah drift 
'c(2) adalah coefficient
'%b(-1) merujuk kepada USD t-1

equation rw.ls log({%b})=c(1)+c(2)*log({%b}(-1))

'nak dapatkan forecast value

smpl %fcst_start %fcst_end
freeze(forecast) rw.forecast(e,g) {%b}_rw   'dynamic forecast. e adalah evaluation table dan g adalah graph
smpl @all

group g1 {%b} {%b}_rw
'==========

%h ="smooth"
graph {%h}.line g1
 {%h}.addtext(ac, textcolor(@rgb(0,0,0)), fillcolor(@rgb(255,255,255)),framecolor(@rgb(0,0,0)),just(c),font(Arial,14,-brent,-i,-usd,-sheet1)) "Actual vs.Smooth" 'tajuk graph

show {%h}

logmsg Fadhilah has finish the Tutorial 6
logmsg Thank you Sir Harun for your video and guideline :)
logmsg Now I am able to write programming in Eviews 10

wfsave {%file}


