/* SCRIPT */

 SET datestyle = dmy;

Create table veiculo (
	Placa		char(7)	    not null,
	Ano		integer	    not null,
	Chassi	        char(17)    not null,
	Primary key (placa) );

Create table motorista (
	NroCNH	        numeric(9) not null,
	ValidadeCNH	date	not null,
	Nome		varchar(30) not null,
	Primary key (nroCNH) );

Create table Rota (
	NroRota		integer not null,
	Nome		varchar(30) not null,
	Primary key (nroRota) );

Create table Viagem (
	NroViagem	integer not null,
	NroRota		integer not null,
	Placa		char(7) not null,
	NroCNH		numeric(9) not null,
	Data		Date	not null,
	Hora		Time	not null,
	Primary key (nroViagem),
        Foreign key (nrorota) references Rota,
        Foreign key (Placa)   references Veiculo,
        Foreign key (nroCNH) references Motorista);

Create table Parada (
	CodParada	integer not null,
	Nome		varchar(30) not null,
	Primary key (codParada) );
	
Create table Itinerario (
	NroRota		integer not null,
	CodParada	integer not null,
	Hora		time	not null,
	Ordem		integer not null,
	Descricao       varchar(100),
	Primary key (NroRota, CodParada, Hora),
        Foreign key (nrorota) references Rota,
        Foreign key (CodParada) references parada);

Create table Item (
        Coditem         integer     not null, 
        descr           varchar(50) not null,
        primary key (coditem) );

Create table Revisoes (
        NroRevisao      integer     not null,  
        Km              integer     not null, 
        Data            date        not null, 
        Placa		char(7) not null,
	NroCNH		numeric(9) not null,
        Primary key (NroRevisao),
        Foreign key (Placa)   references Veiculo,
        Foreign key (nroCNH) references Motorista);

Create table ItensRevisao (
        NroRevisao      integer     not null,  
        Coditem         integer     not null, 
        Qtdade          integer     not null, 
        Valor           numeric(10,2) not null, 
        Primary key (NroRevisao, Coditem),
        Foreign key (NroRevisao)   references Revisoes,
        Foreign key (Coditem) references Item);

--
insert into veiculo values ('AAA1234', 2015, 'XDSEDS111');
insert into veiculo values ('AAB4065', 2014, 'UYXD2ED13');
insert into veiculo values ('AAB3122', 2014, 'UYXD2ED13');

insert into motorista values (480, '20/07/2018', 'Juliano Silva');
insert into motorista values (510, '12/03/2021', 'Ana Marques');
insert into motorista values (515, '01/01/2022', 'Vitoria Mello');

insert into rota values (1, 'Rota das Terras Encantadas');
insert into rota values (2, 'Rota das Salamarias');

insert into parada values (1, 'Selbach');
insert into parada values (2, 'Tapera');
insert into parada values (3, 'Victor Graeff');
insert into parada values (4, 'Marau');
insert into parada values (5, 'Vila Maria');

insert into Itinerario values (1, 1, '08:00', 1, 'Recanto do Mel');
insert into Itinerario values (1, 2, '11:00', 3, 'Orquidário');
insert into Itinerario values (1, 2, '12:00', 3, 'Bella Itália');
insert into Itinerario values (1, 3, '16:00', 4, 'Mais Bela Praça RS');

insert into Itinerario values (2, 1, '10:00', 1, 'Artesanato');
insert into Itinerario values (2, 2, '12:00', 2, 'Cantina / fabricação');

insert into viagem values (1230, 1, 'AAA1234', 480, '21/06/2018', '08:00');
insert into viagem values (1242, 1, 'AAB4065', 510, '21/06/2018', '08:00');
insert into viagem values (1355, 1, 'AAA1234', 480, '22/06/2018', '08:00');
insert into viagem values (1360, 1, 'AAB4065', 515, '22/06/2018', '12:00');
insert into viagem values (1410, 2, 'AAA1234', 510, '20/06/2018', '10:00');
insert into viagem values (1420, 2, 'AAB4065', 515, '20/06/2018', '10:00');
insert into viagem values (1520, 2, 'AAB4065', 480, '21/06/2018', '08:00');



/*Questao 1
Da viagem 1355, mostrar o seu itinerário: nome da rota, ordem, horário previsto,
nome da parada e a descrição do itinerário.
*/
select v.nroviagem, r.nome, i.ordem , v.hora, p.nome , i.descricao
from rota as r , itinerario as i, viagem as v, parada as p
where v.nrorota = r.nrorota
and v.nrorota = i.nrorota
and i.codparada = p.codparada
and v.nroviagem = 1355;

/*Questão 2
Do veículo de placa = 'AAA1234' selecionar as suas revisões, mostrando:
número da revisão, data, km, descrição do item, quantidade e valor.
(Álgebra Relacional)
*/
/* 
PI revisoes.nrorevisao , revisoes.data, revisoes.km, item.descr, 
itensrevisao.qtdade, itensrevisao.valor
SIGMA itensrevisao.NroRevisao = revisoes.NroRevisao ^
	itensrevisao.Coditem = item.Coditem ^
	revisoes.placa = 'AAA1234'
(revisoes , item, itensrevisao)
*/

select r.NroRevisao , r.data, r.km, i.descr, ir.Qtdade, ir.valor
from revisoes as r, item as i, ItensRevisao as ir, veiculo as v
where ir.NroRevisao = r.NroRevisao
and ir.Coditem = i.Coditem
and r.placa = 'AAA1234';

/*Questão 3
Criar uma visão que retorne as descrições dos itinerários da
'Rota das Salamarias', mostrando:
a ordem e a descrição do itinerário.
*/
create view v_iti_descr AS
     select i.ordem , i.Descricao
     from Itinerario as i, rota as r
     where i.NroRota = r.NroRota
     and r.Nome = 'Rota das Salamarias';

     select * from v_iti_descr;

/*Questão 4
Mostrar os veículos (placa e número do chassi) que não tiveram nenhuma viagem.
*/
select placa, chassi
from veiculo
where placa NOT IN (select Placa from viagem); 

-- veiculos que SIM, tiveram viagem
select distinct ve.placa, ve.chassi
from veiculo as ve, viagem as vi
where ve.placa = vi.placa;


/*Questão 5
Mostrar a placa dos veículos que já foram utilizados em viagens para a rota 1 e rota 2.
*/
select veiculo.placa
from veiculo, viagem
where veiculo.placa = viagem.placa
and viagem.NroRota = 1
INTERSECT
select veiculo.placa
from veiculo, viagem
where veiculo.placa = viagem.placa
and viagem.NroRota = 2;


/*Questao 6
Mostrar o nome da rota que mais teve viagens*/
create view v_rota_viagens as
select rota.nome , count(viagem.nrorota) as nro_viagens
from rota, viagem
where rota.nrorota = viagem.nrorota
group by rota.nome;

select nome as NomeDaRotaComMaisViagens
from v_rota_viagens
where nro_viagens = (select max(nro_viagens) from v_rota_viagens);


/* Questao 7
Mostrar o nome do motorista que realizou viagens, com sua CNH por vencer
a menos de 30 dias (considerar a data de viagem)*/

create view v_motorista_vencimento_cnh as
select motorista.nome, motorista.validadecnh as val_cnh, viagem.Data as data_viagem,
motorista.validadecnh::date - viagem.Data::date as num_dias
from motorista, viagem
where motorista.NroCNH = viagem.NroCNH;

select nome, num_dias 
from v_motorista_vencimento_cnh
where num_dias < 30;

select * from v_motorista_vencimento_cnh

/*Questao 8
para cada veiculo, selecionar as suas viagens, mostrando a placa, numero do chassi,
numero da viagem e data da viagem. Incluir tambem no resultado os veiculos
que ainda nao realizaram viagem.*/

select vei.Placa, vei.chassi,viag.NroViagem , viag.data
from viagem as viag right join veiculo as vei
on viag.placa = vei.placa;
