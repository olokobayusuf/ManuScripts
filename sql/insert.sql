
USE `kfarmer_db`;

SELECT * FROM author;

INSERT INTO `user` (`id`,`fname`,`lname`) VALUES (1,"Vielka","Cruz"),(2,"Palmer","Snow"),(3,"William","Joyner"),(4,"Imani","Kirk"),(5,"Veda","Mcpherson"),(6,"Dylan","Nash"),(7,"Dawn","Warner"),(8,"Hamilton","Hendricks"),(9,"Shoshana","Shepard"),(10,"Cleo","Short");
INSERT INTO `user` (`id`,`fname`,`lname`) VALUES (11,"Ryder","Henderson"),(12,"Chandler","Hoover"),(13,"Branden","Odonnell"),(14,"Finn","Branch"),(15,"Dillon","Tran"),(16,"Travis","Harvey"),(17,"Shad","Noel"),(18,"Randall","Wheeler"),(19,"Samantha","Cote"),(20,"Charissa","Phillips");

INSERT INTO `editor` (`user_id`)
	VALUES (1),(2);
    

INSERT INTO `affiliation` (`id`,`institution`) VALUES (1,"Morbi Vehicula Pellentesque LLC"),(2,"Dolor Donec Industries"),(3,"Auctor Velit Corp."),(4,"Morbi Metus LLP"),(5,"Turpis Nec Mauris Limited"),(6,"Lorem Company"),(7,"Aliquam Nisl Corp."),(8,"Mauris Elit Company"),(9,"Magna Duis Dignissim Ltd"),(10,"Curabitur Inc.");
INSERT INTO `affiliation` (`id`,`institution`) VALUES (11,"Vehicula Risus Limited"),(12,"Blandit Consulting"),(13,"Sollicitudin Corporation"),(14,"Purus Company"),(15,"Ut Foundation"),(16,"Sem Vitae Aliquam Consulting"),(17,"Mollis Lectus Pede Corporation"),(18,"Ac Tellus Corp."),(19,"At Egestas A Corporation"),(20,"Rutrum Lorem Inc.");


INSERT INTO `author` (`user_id`,`address`,`email`,`affiliation_id`) 
	VALUES 
    (3,"Ap #367-6654 Lorem Rd.","ac.ipsum@libero.edu",3),
    (4,"P.O. Box 732, 1502 Arcu. Street","Cras.vehicula@ullamcorper.com",5),
    (5,"Ap #618-9798 Eleifend St.","ac.mattis@leoMorbi.edu",4),
    (6,"P.O. Box 814, 4043 Velit. Road","sociis.natoque@Mauris.ca",15),
    (7,"P.O. Box 318, 791 Lorem Road","vitae.sodales.nisi@egestasligula.net",20),
    (8,"Ap #555-8087 Nulla Road","dolor@nequeet.ca",9),
    (9,"407-5392 Suspendisse Rd.","Proin.vel@lobortisauguescelerisque.co.uk",4),
    (10,"Ap #330-2509 Lorem Street","aliquam.eros.turpis@cursus.com",8),
    (11,"Ap #369-3632 Hendrerit Rd.","orci.sem@rhoncusidmollis.ca",4),
    (12,"7180 Amet, Street","in.sodales.elit@Phasellusvitaemauris.org",10);
    
    
INSERT INTO `reviewer` (`user_id`,`email`,`affiliation_id`) 
	VALUES (13,"orci.Phasellus@nequevitaesemper.org",8),
    (14,"libero.lacus.varius@lobortisultricesVivamus.edu",1),
    (15,"orci@miacmattis.com",19),
    (16,"lacus@posuereat.org",4),
    (17,"ridiculus@semperauctor.net",14),
    (18,"sollicitudin@interdumlibero.edu",13),
    (19,"vehicula@posuereenimnisl.ca",1),
    (20,"aliquam.eu@a.co.uk",15);
    


    
    
    
    