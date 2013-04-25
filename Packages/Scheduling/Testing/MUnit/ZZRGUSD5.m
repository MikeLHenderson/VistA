ZZRGUSD5 ;RGI/CBR Unit Tests - Vocabulary API; 4/16/13
 ;;1.0;UNIT TEST;;05/28/2012;
 Q:$T(^SDMAPI1)=""
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZRGUSD5")
 TROLLBACK
 Q
STARTUP ;
 S DTIME=500,DUZ=1,U="^"
 D LOGON^ZZRGUSDC
 S DT=$$DT^XLFDT()
 D SETUP^ZZRGUSDC()
 Q
 ;
SHUTDOWN ;
 Q
 ;
LSTAPPST ;
 N R,%
 S %=$$LSTAPPST^SDMAPI1(.R)
 D CHKEQ^XTMUNIT(%,1,"Unexpected error: "_$G(R(0)))
 D CHKEQ^XTMUNIT($G(R(0)),8)
 D CHKEQ^XTMUNIT($G(R(1)),"N^NO-SHOW")
 D CHKEQ^XTMUNIT($G(R(2)),"C^CANCELLED BY CLINIC")
 D CHKEQ^XTMUNIT($G(R(3)),"NA^NO-SHOW & AUTO RE-BOOK")
 D CHKEQ^XTMUNIT($G(R(4)),"CA^CANCELLED BY CLINIC & AUTO RE-BOOK")
 D CHKEQ^XTMUNIT($G(R(5)),"I^INPATIENT APPOINTMENT")
 D CHKEQ^XTMUNIT($G(R(6)),"PC^CANCELLED BY PATIENT")
 D CHKEQ^XTMUNIT($G(R(7)),"PCA^CANCELLED BY PATIENT & AUTO-REBOOK")
 D CHKEQ^XTMUNIT($G(R(8)),"NT^NO ACTION TAKEN")
 Q
LSTHLTP ;
 N R,%
 S %=$$LSTHLTP^SDMAPI1(.R)
 D CHKEQ^XTMUNIT(%,1,"Unexpected error: "_$G(R(0)))
 D CHKEQ^XTMUNIT($G(R(0)),8)
 D CHKEQ^XTMUNIT($G(R(1)),"C^CLINIC")
 D CHKEQ^XTMUNIT($G(R(2)),"M^MODULE")
 D CHKEQ^XTMUNIT($G(R(3)),"W^WARD")
 D CHKEQ^XTMUNIT($G(R(4)),"Z^OTHER LOCATION")
 D CHKEQ^XTMUNIT($G(R(5)),"N^NON-CLINIC STOP")
 D CHKEQ^XTMUNIT($G(R(6)),"F^FILE AREA")
 D CHKEQ^XTMUNIT($G(R(7)),"I^IMAGING")
 D CHKEQ^XTMUNIT($G(R(8)),"OR^OPERATING ROOM")
 Q
LSTSRT ;
 N R,%
 S %=$$LSTSRT^SDMAPI1(.R)
 D CHKEQ^XTMUNIT(%,1,"Unexpected error: "_$G(R(0)))
 D CHKEQ^XTMUNIT($G(R(0)),7)
 D CHKEQ^XTMUNIT($G(R(1)),"N^'NEXT AVAILABLE' APPT.")
 D CHKEQ^XTMUNIT($G(R(2)),"C^OTHER THAN 'NEXT AVA.' (CLINICIAN REQ.)")
 D CHKEQ^XTMUNIT($G(R(3)),"P^OTHER THAN 'NEXT AVA.' (PATIENT REQ.)")
 D CHKEQ^XTMUNIT($G(R(4)),"W^WALKIN APPT.")
 D CHKEQ^XTMUNIT($G(R(5)),"M^MULTIPLE APPT. BOOKING")
 D CHKEQ^XTMUNIT($G(R(6)),"A^AUTO REBOOK")
 D CHKEQ^XTMUNIT($G(R(7)),"O^OTHER THAN 'NEXT AVA.' APPT.")
 Q
LSTSBCTG ;
 Q:$T(^DGSAAPI)=""
 D SUBTYP^ZZRGUSDC
 N R,%
 S %=$$LSTSBCTG^DGSAAPI(.R)
 D CHKEQ^XTMUNIT(%,1,"Unexpected error: "_$G(R(0)))
 D CHKEQ^XTMUNIT($G(R(0)),2)
 D CHKEQ^XTMUNIT($G(R(1)),"1^Sharing 1")
 D CHKEQ^XTMUNIT($G(R(2)),"2^Sharing 2")
 Q
PTFU ;
 N %,RETURN
 S RTN="S %=$$PTFU^SDMAPI1(.RETURN,.PAT,.CLN)"
 D EXSTPAT^ZZRGUSD5(RTN)
 D EXSTCLN^ZZRGUSD5(RTN)
 Q
HASPEND ;
 N %,RETURN,RE
 S RTN="S %=$$HASPEND^SDMAPI1(.RETURN,.PAT)"
 D EXSTPAT^ZZRGUSD5(RTN)
 S %=$$HASPEND^SDMAPI1(.RE,DFN)
 D CHKEQ^XTMUNIT(RE,0,"No pending appt")
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD,TYPE,,LEN,NXT,RSN)
 S %=$$HASPEND^SDMAPI1(.RE,DFN)
 D CHKEQ^XTMUNIT(RE,1,"Has pending appt")
 Q
EXSTPAT(RTN) ;
 N %,RETURN
 ;Invalid patient param
 K PAT S CLN=SC X RTN
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"INVPARAM","Expected error: INVPARAM")
 ;patient does not exist
 S PAT=DFN+1,CLN=SC X RTN
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: PATNFND")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"PATNFND","Expected error: PATNFND")
 Q
EXSTCLN(RTN) ;
 N %,RETURN
 ;Invalid clinic param
 S CLN=0,PAT=DFN X RTN
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"INVPARAM","Expected error: INVPARAM")
 ;clinic does not exist
 S CLN=9999999,PAT=DFN X RTN
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNNFND")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"CLNNFND","Expected error: CLNNFND")
 Q
CHECKO ;
 N %,RETURN,RE,R
 K ^DPT(+DFN,"S"),^SC(+SC,"S") S SD=$$FMADD^XLFDT(SD,,1)
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD,TYPE,,LEN,NXT,RSN)
 S RTN="S %=$$CHECKO^SDMAPI4(.RETURN,.PAT,SD,.CLN)"
 D EXSTPAT^ZZRGUSD5(RTN),EXSTCLN^ZZRGUSD5(RTN)
 ;undefined SD
 S %=$$CHECKO^SDMAPI4(.RE,DFN,,SC)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected: INVPARAM SD")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["SD",1,"Expected: INVPARAM SD")
 ;appt not found
 S %=$$CHECKO^SDMAPI4(.RE,DFN,2,SC)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^APTNFND","Expected: APTNFND")
 ;
 S %=$$CHECKO^SDMAPI4(.RETURN,DFN,SD,SC),NOW=$$NOW^XLFDT()
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 S SC0=+DFN_"^"_+LEN_"^^"_RSN_"^^"_DUZ_"^"_DT_"^^^"
 S SCC="^^"_NOW_"^"_DUZ_"^^"_NOW
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+SD,1,1,0),SC0,"Invalid clinic appointment - 0 node")
 S SDOE=RETURN("SDOE")
 S DPT0=+SC_"^^^^^^3^^^^^^^^^"_+TYPE_"^^"_DUZ_"^"_DT_"^"_SDOE_"^^^^0^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(+DFN,"S",+SD,0),DPT0,"Invalid patient appointment - 0 node")
 ; Invalid SDOE param
 S %=$$GETOE^SDMAPI4(.R,"AAA")
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^INVPARAM","Expected error: INVPARAM")
 ; Outpatient encounter not found
 S %=$$GETOE^SDMAPI4(.R,SDOE+1)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^OENFND","Expected error: OENFND")
 S %=$$GETOE^SDMAPI4(.R,SDOE)
 S NOD=R(.01)_U_R(.02)_U_R(.03)_U_R(.04)_U_R(.05)_U_U_R(.07)_U_R(.08)
 D CHKEQ^XTMUNIT(NOD,$P(^SCE(SDOE,0),U,1,8),"Invalid encounter")
 S %=$$CHECKO^SDMAPI4(.RETURN,DFN,SD,SC),NOW=$$NOW^XLFDT()
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTCOAC")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTCOAC","Expected error: APTCOAC")
 Q
DELCO ;
 N %,RETURN,RE
 S ^XUSEC("SD SUPERVISOR",+DUZ)=""
 S RTN="S %=$$DELCOSD^SDMAPI4(.RETURN,.PAT,SD)" D EXSTPAT^ZZRGUSD5(RTN)
 ;undefined SD
 S %=$$DELCOSD^SDMAPI4(.RE,DFN)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected: INVPARAM SD")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["SD",1,"Expected: INVPARAM SD")
 ;appt not found
 S %=$$DELCOSD^SDMAPI4(.RE,DFN,2)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^APTNFND","Expected: APTNFND")
 ;
 S %=$$DELCOSD^SDMAPI4(.RETURN,DFN,SD),NOW=$$NOW^XLFDT()
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 S SC0=+DFN_"^"_+LEN_"^^"_RSN_"^^"_DUZ_"^"_DT_"^^^"
 S SCC="^^^^^"
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+SD,1,1,0),SC0,"Invalid clinic appointment - 0 node")
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+SD,1,1,"C"),SCC,"Invalid clinic appointment - C node")
 S DPT0=+SC_"^^^^^^3^^^^^^^^^"_+TYPE_"^^"_DUZ_"^"_DT_"^"_SDOE_"^^^^0^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(+DFN,"S",+SD,0),DPT0,"Invalid patient appointment - 0 node")
 S OE=RETURN("OE") K RETURN
 S $P(^SCE(OE,0),U,8)=3,^SCE(OE+1,0)=^SCE(OE,0),$P(^SCE(OE+1,0),U,6)=OE
 S ^SCE("APAR",OE,OE+1)=""
 S %=$$GETCHLD^SDMAPI4(.RETURN,OE)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 S %=$$DELCOPC^SDMAPI4(.RETURN,OE,,"PCE")
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 Q
MAKECAN ;
 N %,RE
 K ^DPT(+DFN,"S"),^SC(+SC,"S") S SD=$$FMADD^XLFDT(SD,,1)
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SD,TYPE,,LEN,NXT,RSN)
 D CHKEQ^XTMUNIT(RE,1,"Unxpected error: "_$G(RE(0)))
 S ^XUSEC("SDOB",DUZ)="",^XUSEC("SDMOB",DUZ)=""
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SD,TYPE,,LEN,NXT,RSN,,,,,,,1)
 D CHKEQ^XTMUNIT(RE,1,"Unxpected error: "_$G(RE(0)))
 S SC1=$$ADDCLN^ZZRGUSDC("Test Cancel Clinic")
 D ADDPATT^ZZRGUSDC(+SC1)
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC1,SD,TYPE,,LEN,NXT,RSN)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^APTPAHA","Unxpected error: "_$G(RE(0)))
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,SD,TYPE,,LEN,NXT,RSN,,,,,,,1)
 D CHKEQ^XTMUNIT(RE,1,"Unxpected error: "_$G(RE(0)))
 Q
DISCH ;
 N RSN,RE,ENS,RETURN
 S RSN="Discharge reason"
 ;Patient not enrolled.
 S %=$$DISCH^SDMAPI3(.RE,DFN,SD)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^PATNAEAC","Expected error: PATNAEAC")
 ;
 S %=$$MAKE^SDMAPI2(.RE,DFN,SC,$$FMADD^XLFDT(+SD,1),TYPE,,LEN,NXT,RSN,,,,,,,1)
 S SC1=$$ADDCLN^ZZRGUSDC("Disch Clinic"),SCT=SC,SC=SC1
 S RTN="S %=$$GETPENRL^SDMAPI3(.RETURN,.PAT,.CLN)" D EXSTPAT^ZZRGUSD5(RTN),EXSTCLN^ZZRGUSD5(RTN)
 S %=$$GETPENRL^SDMAPI3(.ENS,DFN,SC1,"A")
 D CHKEQ^XTMUNIT(ENS_U_$P(ENS(0),U),"0^INVPARAM","Expected error: INVPARAM")
 S SC=SCT
 S %=$$GETPENRL^SDMAPI3(.ENS,DFN,SC1)
 D CHKEQ^XTMUNIT(ENS(+SC1,"NAME"),"Disch Clinic","Expected clinic: Disch Clinic")
 D SETENR^ZZRGUSDC(DFN,SC)
 S %=$$GETPENRL^SDMAPI3(.ENS,DFN,SC)
 D CHKEQ^XTMUNIT(ENS(+SC,"STATUS"),"","Expected status: Active")
 D CHKEQ^XTMUNIT(ENS(+SC,"EN",1,"ENROLLMENT"),DT,"Invalid enrollment date")
 S ENS(+SC,"EN",1,"DISCHARGE")=DT
 S ENS(+SC,"EN",1,"REASON")=RSN
 S RTN="S %=$$DISCH^SDMAPI3(.RETURN,.PAT,.SD,.CLN)" D EXSTPAT^ZZRGUSD5(RTN),EXSTCLN^ZZRGUSD5(RTN)
 ; invalid date
 S %=$$DISCH^SDMAPI3(.RE,DFN)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected error: INVPARAM")
 S %=$$DISCH^SDMAPI3(.RE,DFN,"AAA")
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected error: INVPARAM")
 ; patient has future appts
 S %=$$DISCH^SDMAPI3(.RE,DFN,SD)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^PATDHFA","Expected error: PATDHFA")
 ; discharge
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S %=$$DISCH^SDMAPI3(.RETURN,DFN,SD,SC,RSN)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT(^DPT(+DFN,"DE",1,0),+SC_"^I","Expected status: Inactive")
 D CHKEQ^XTMUNIT(^DPT(+DFN,"DE",1,1,1,0),DT_"^O^"_DT_U_RSN_U,"Expected status: Inactive")
 ;Patient not enrolled.
 S %=$$DISCH^SDMAPI3(.RE,DFN,SD)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^PATNAEAC","Expected error: PATNAEAC")
 ; Patient not enrolled in... clinic
 S %=$$DISCH^SDMAPI3(.RE,DFN,SD,+SC2,RSN)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^PATDNEN","Expected error: PATDNEN")
 ; already discharged
 S %=$$DISCH^SDMAPI3(.RE,DFN,SD,+SC,RSN)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^PATDARD","Expected error: PATDARD")
 ; discharge active enrolls
 S $P(^DPT(+DFN,"DE",1,0),U,2)=""
 S %=$$DISCH^SDMAPI3(.RE,DFN,SD,,RSN)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 Q
XTENT ;
 ;;LSTAPPST;List appointment statuses
 ;;LSTHLTP;List hospital location types
 ;;LSTSRT;List scheduling request types
 ;;LSTSBCTG;List sharing agreement sub-categories
 ;;PTFU;;Follow-up
 ;;HASPEND;;Has pending apptS
 ;;CHECKO;Check out appointment
 ;;DELCO;Delete check out
 ;;MAKECAN;Make & Cancel
 ;;DISCH;Discharge from clinic
