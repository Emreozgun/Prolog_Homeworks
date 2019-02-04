%%%%%%%%%%%%%%%%%%EMRE ÖZGÜN----161044103----PART-1%%%%%%%%%%%%%%%%%%%%%%%%% 

:- discontiguous e/2. % Farklı argüman sayısına sahip factlerde warning verdigi  
:- discontiguous o/2. % için kullandım(İnternetten alındı).
:- discontiguous o/3.
:- discontiguous i/3.
:- discontiguous s/4.
:- discontiguous s/3.
:- discontiguous s/5.

%Room facts data.txt den alındı.Ekstra kendimde ekledim.
r(z06,10,equipment(hcapped,projector)). 
r(z11,10,equipment(hcapped,smartboard)).
%r(room1,10,equipment(hcapped)). %Kendim ekledim 
%r(room2,10,equipment()).	%Kendim ekledim

%Course facts data.txt den alındı
c(cse341,genc,10,4,z06).
c(cse343,turker,6,3,z11).
c(cse331,bayrakci,5,3,z06).
c(cse321,gozupek,10,4,z11).
%c(cse100,a,10,3,z11). % Kendim assign işlemini kontrol için ekledim

%Student facts data.txt den alındı.
s(1,cse341,cse343,cse331,no).
s(2,cse341,cse343,no).
s(3,cse331,cse331,no).
s(4,cse341,no).
s(5,cse343,cse331,no).
s(6,cse341,cse343,cse331,yes).
s(7,cse341,cse343,no).
s(8,cse341,cse331,yes).
s(9,cse341,no).
s(10,cse341,cse321,no).
s(11,cse341,cse321,no).
s(12,cse343,cse321,no).
s(13,cse343,cse321,no).
s(14,cse343,cse321,no).
s(15,cse343,cse321,yes).

%Instruction facts data.txt den alındı.
i(genc,cse341,projector).
i(turker,cse343,smartboard).
i(bayrakci,cse331).
i(gozupek,cse321,smartboard).

%Occupancy facts data.txt den alındı.
o(z06,8,cse341).
o(z06,9,cse341).
o(z06,10,cse341).
o(z06,11,cse341).
o(z06,12,cse341).
o(z06,13).
o(z06,14).
o(z06,15).
o(z06,16).
o(z11,8,cse343).
o(z11,9,cse343).
o(z11,10,cse343).
o(z11,11,cse343).
o(z11,12).
o(z11,13).
o(z11,14,cse321).
o(z11,15,cse321).
o(z11,16,cse321).

%Tüm equipmentlerin factleri
e(hcapped,projector).
e(hcapped,smartboard).
e(projector).
e(smartboard).
e(smartboard,projector).

%Equipments rules
equipment(). 
equipment(X) :- e(X).
equipment(X,Y) :- e(X,Y);e(Y,X).


%Yeni eklenen room için daha önce öyle bir sınıf tanımlanmış mı ve girelen equipmentler doğru mu diye kontrol ettim
addRoom(Name,Capacity,Equipment1,Equipment2):- not(r(Name,_,equipment(_,_))),
    			  equipment(Equipment1,Equipment2),
    			  Capacity > 0.
addRoom(Name,Capacity,Equipment1):- not(r(Name,_,equipment(_))),
    			  equipment(Equipment1),
    			  Capacity > 0.
addRoom(Name,Capacity):- not(r(Name,_,equipment())),
    			  equipment(),
    			  Capacity > 0.

needs(Equipment) :- equipment(Equipment).%Yeni eklenen room'lar için kullandığım rulelar.

addInstructor(Name,Course,Equipment):-  not(i(_,Course,_)),
  						not(c(Course,_,_,_,_)),
    					not(c(_,Name,_,_,_)),
    					needs(Equipment).
    					
addInstructor(Name,Course):-  not(i(Name,Course)),
    				  not(c(Course,_,_,_,_)),
    				  not(c(_,Name,_,_,_)).

%2 farklı handicapped var(yes veya no).
checkHandicapped(Hcapped) :-  Hcapped = yes;
							  Hcapped = no.
%%Yeni eklenen öğrenciler için kullandığım rulelar (True yada false cevabı verir).
%Eklenen yeni öğrencinin özelliklerinin doğruluğunu kontrol eder.
addStudent(StudentId,Courses,Hcapped) :- checkHandicapped(Hcapped),
    									 not(s(StudentId,_,_,_,_)),
										 not(s(StudentId,_,_,_)),
										 not(s(StudentId,_,_)),
    									 c(Courses,_,_,_,_).
addStudent(StudentId,Courses1,Courses2,Hcapped) :- 
    									 checkHandicapped(Hcapped),
    									 not(s(StudentId,_,_,_,_)),
										 not(s(StudentId,_,_,_)),
										 not(s(StudentId,_,_)),
    									 c(Courses1,_,_,_,_),
    									 c(Courses2,_,_,_,_).
addStudent(StudentId,Courses1,Courses2,Courses3,Hcapped) :- 
    									 checkHandicapped(Hcapped),
    									 not(s(StudentId,_,_,_,_)),
										 not(s(StudentId,_,_,_)),
										 not(s(StudentId,_,_)),
    									 c(Courses1,_,_,_,_),
										 c(Courses2,_,_,_,_),
    									 c(Courses3,_,_,_,_).


%addCourse işlemi için tanımlanan odanın var olup olmadığını kontrol eder.
check_Rooms(Room) :- r(Room,_,equipment(_,_));
    				 r(Room,_,equipment(_));
    				 r(Room,_,equipment()).
%addCourse işlemi için tanımlanan instructionın var olup olmadığını kontrol eder.		 	
check_Ins(Ins) :- i(Ins,_,_);
    			  i(Ins,_).
%Ders ekleme işlemi yaparken argüman olarak kullanılan ders,öğretmen ve room fact olarak tanımlanmış mı onu kontrol ettim
%saat için sınırlama ekledim.Kapasite içinde 0 dan büyük kontrolü yaptım.
addCourse(Course,Ins,Capacity,Hour,Room):-
    								check_Rooms(Room),
    								Hour < 10,
    								Capacity >0,
    								not(c(Course,_,_,_,_)),
                                    check_Ins(Ins).
 
check_enroll(Hcapped,Handicapped) :- Hcapped = hcapped,
    								 Handicapped = yes.

check_Student(RoomID,Handicapped) :- %write(RoomID).
    								 r(RoomID,_,equipment(Hcapped,_)),
    								 check_enroll(Hcapped,Handicapped).

check_no_handicapped(Handicapped,CourseID):- Handicapped = no,	
    										c(CourseID,_,_,_,_).

%Bir öğrenci dersi alabilmesi için handicapped özelliğine sahip olmalı ve course'un verildiği oda da handicapped'li olan öğrenciler 
%için uygun olmalıdır.Ben bu koşullara bakara enroll işlemini yaptım. 
enroll(StudentID,CourseID) :-
    		s(StudentID,_,_,Handicapped),
    		check_no_handicapped(Handicapped,CourseID).
enroll(StudentID,CourseID) :-
    		s(StudentID,_,_,_,Handicapped),
    		check_no_handicapped(Handicapped,CourseID).
enroll(StudentID,CourseID) :-
    		s(StudentID,_,Handicapped),
    		check_no_handicapped(Handicapped,CourseID).

enroll(StudentID,CourseID) :-
    		s(StudentID,_,Handicapped),
    		c(CourseID,_,_,_,RoomID),
			check_Student(RoomID,Handicapped).

enroll(StudentID,CourseID) :-s(StudentID,_,_,Handicapped),
                             c(CourseID,_,_,_,RoomID),
    						 check_Student(RoomID,Handicapped).

enroll(StudentID,CourseID) :-
    		s(StudentID,_,_,_,Handicapped),
    		c(CourseID,_,_,_,RoomID),
    		check_Student(RoomID,Handicapped).

check_Room_conflict(Room1,Room2) :- Room1 = Room2.

check_hour(FirstHour,SecondHour) :- FirstHour =:= SecondHour.

check_assign(RoomId,H) :- RoomId = z06,
    					  H =< 4.
check_assign2(RoomId,H) :- RoomId = z11,
    					  H =< 2.

%İnput olarak verilen dersin kaç saatlik ders olduğunu bulup o dersin verildiği sınıfta kaç saat boşluğu olduğuna göre karşılaştırma yaparak %%%% assign işlemini yaptım   
assign(RoomID,CourseID) :- c(CourseID,_,_,H,RoomID),
							check_assign(RoomID,H).

assign(RoomID,CourseID) :- c(CourseID,_,_,H,RoomID),
						   check_assign2(RoomID,H).
    					     


%İnput olarak verilen derslerin occupany factlerinden aynı saatte olup olmadığını yani çakışması olup olmadığına baktım.
% conflict rule'unda eğer farklı sınıflarda ise saatlere bakmadan aynı işlemin cevabını false olarak döner(Herhangi bir kafa karışıklığı yok)
% conflicts2 rule'unda ise aynı roomda olan iki sınıfın tüm saatlerine bakıp aynı saatte olan bir çakışma varsa true döner.  
conflicts(CourseID1,CourseID2):- c(CourseID1,_,_,_,Room1),	
    							 c(CourseID2,_,_,_,Room2),
    							 check_Room_conflict(Room1,Room2),
    							 conflicts2(CourseID1,CourseID2).

conflicts2(CourseID1,CourseID2) :- o(_,FirstHour,CourseID1),
    							   o(_,SecondHour,CourseID2),
    							   check_hour(FirstHour,SecondHour).

