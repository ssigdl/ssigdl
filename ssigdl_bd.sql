SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `ssigdl` ;
CREATE SCHEMA IF NOT EXISTS `ssigdl` DEFAULT CHARACTER SET utf8 COLLATE utf8_spanish_ci ;
USE `ssigdl` ;

-- -----------------------------------------------------
-- Table `ssigdl`.`ssi_categoria`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ssigdl`.`ssi_categoria` ;

CREATE TABLE IF NOT EXISTS `ssigdl`.`ssi_categoria` (
  `cat_id` INT NOT NULL AUTO_INCREMENT,
  `cat_nombre` VARCHAR(100) NULL,
  `cat_descripcion` VARCHAR(255) NULL,
  `cat_super_id_fk` INT NULL,
  PRIMARY KEY (`cat_id`),
  INDEX `fk_ssi_categoria_ssi_categoria1_idx` (`cat_super_id_fk` ASC),
  CONSTRAINT `fk_ssi_categoria_ssi_categoria1`
    FOREIGN KEY (`cat_super_id_fk`)
    REFERENCES `ssigdl`.`ssi_categoria` (`cat_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ssigdl`.`ssi_articulo_unidad_medida`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ssigdl`.`ssi_articulo_unidad_medida` ;

CREATE TABLE IF NOT EXISTS `ssigdl`.`ssi_articulo_unidad_medida` (
  `arum_id` INT NOT NULL AUTO_INCREMENT,
  `arum_descripcion` VARCHAR(255) NULL,
  PRIMARY KEY (`arum_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ssigdl`.`ssi_articulo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ssigdl`.`ssi_articulo` ;

CREATE TABLE IF NOT EXISTS `ssigdl`.`ssi_articulo` (
  `art_id` INT NOT NULL AUTO_INCREMENT,
  `art_nombre_producto` VARCHAR(100) NULL,
  `art_marca` VARCHAR(50) NULL,
  `art_descripcion` VARCHAR(255) NULL,
  `art_cantidad` SMALLINT NULL DEFAULT 0,
  `art_precio_unitario` DECIMAL(10,2) NULL DEFAULT 0.00,
  `art_subtotal` DECIMAL(10,2) NULL DEFAULT 0.00,
  `art_imagen` VARCHAR(255) NULL,
  `art_cat_id_fk` INT NOT NULL,
  `art_arum_id_fk` INT NOT NULL,
  PRIMARY KEY (`art_id`),
  INDEX `fk_ssi_articulo_ssi_articulo_cat1_idx` (`art_cat_id_fk` ASC),
  INDEX `fk_ssi_articulo_ssi_articulo_unidad_medida1_idx` (`art_arum_id_fk` ASC),
  CONSTRAINT `fk_ssi_articulo_ssi_articulo_cat1`
    FOREIGN KEY (`art_cat_id_fk`)
    REFERENCES `ssigdl`.`ssi_categoria` (`cat_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ssi_articulo_ssi_articulo_unidad_medida1`
    FOREIGN KEY (`art_arum_id_fk`)
    REFERENCES `ssigdl`.`ssi_articulo_unidad_medida` (`arum_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ssigdl`.`ssi_empresa_cat`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ssigdl`.`ssi_empresa_cat` ;

CREATE TABLE IF NOT EXISTS `ssigdl`.`ssi_empresa_cat` (
  `empc_id` INT NOT NULL AUTO_INCREMENT,
  `empc_descripcion` VARCHAR(100) NULL,
  PRIMARY KEY (`empc_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ssigdl`.`ssi_direccion_empresa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ssigdl`.`ssi_direccion_empresa` ;

CREATE TABLE IF NOT EXISTS `ssigdl`.`ssi_direccion_empresa` (
  `dire_id` INT NOT NULL AUTO_INCREMENT,
  `dire_contacto` VARCHAR(100) NULL,
  `dire_email` VARCHAR(60) NULL,
  `dire_direccion` VARCHAR(60) NULL,
  `dire_colonia` VARCHAR(45) NULL,
  `dire_sucursal` VARCHAR(45) NULL,
  `dire_municipio` VARCHAR(45) NULL,
  `dire_estado` VARCHAR(45) NULL,
  PRIMARY KEY (`dire_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ssigdl`.`ssi_empresa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ssigdl`.`ssi_empresa` ;

CREATE TABLE IF NOT EXISTS `ssigdl`.`ssi_empresa` (
  `emp_id` INT NOT NULL AUTO_INCREMENT,
  `emp_nombre` VARCHAR(100) NULL,
  `emp_fecha_registro` DATE NULL DEFAULT '0001-01-01',
  `emp_rfc` VARCHAR(20) NULL,
  `emp_dire_id_fk` INT NOT NULL,
  `emp_empc_id_fk` INT NOT NULL,
  PRIMARY KEY (`emp_id`),
  INDEX `fk_ssi_empresa_ssi_direccion_empresa1_idx` (`emp_dire_id_fk` ASC),
  INDEX `fk_ssi_empresa_ssi_empresa_cat1_idx` (`emp_empc_id_fk` ASC),
  CONSTRAINT `fk_ssi_empresa_ssi_direccion_empresa1`
    FOREIGN KEY (`emp_dire_id_fk`)
    REFERENCES `ssigdl`.`ssi_direccion_empresa` (`dire_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ssi_empresa_ssi_empresa_cat1`
    FOREIGN KEY (`emp_empc_id_fk`)
    REFERENCES `ssigdl`.`ssi_empresa_cat` (`empc_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ssigdl`.`ssi_factura`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ssigdl`.`ssi_factura` ;

CREATE TABLE IF NOT EXISTS `ssigdl`.`ssi_factura` (
  `fact_id` INT NOT NULL AUTO_INCREMENT,
  `fact_numero` VARCHAR(30) NULL,
  `fact_concepto` VARCHAR(100) NULL,
  `fact_fecha` DATE NULL DEFAULT '0001-01-01',
  `fact_lugar_expedicion` VARCHAR(100) NULL,
  `fact_total` DECIMAL(10,2) NULL DEFAULT 0.00,
  `fact_emp_id_fk` INT NOT NULL,
  PRIMARY KEY (`fact_id`),
  INDEX `fk_ssi_factura_ssi_empresa1_idx` (`fact_emp_id_fk` ASC),
  CONSTRAINT `fk_ssi_factura_ssi_empresa1`
    FOREIGN KEY (`fact_emp_id_fk`)
    REFERENCES `ssigdl`.`ssi_empresa` (`emp_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ssigdl`.`ssi_servicio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ssigdl`.`ssi_servicio` ;

CREATE TABLE IF NOT EXISTS `ssigdl`.`ssi_servicio` (
  `serv_id` INT NOT NULL AUTO_INCREMENT,
  `serv_nombre` VARCHAR(100) NULL,
  `serv_descripcion` VARCHAR(255) NULL,
  `serv_precio` DECIMAL(10,2) NULL DEFAULT 0.00,
  `serv_imagen` VARCHAR(255) NULL,
  `serv_cat_id_fk` INT NOT NULL,
  PRIMARY KEY (`serv_id`),
  INDEX `fk_ssi_servicio_ssi_articulo_cat1_idx` (`serv_cat_id_fk` ASC),
  CONSTRAINT `fk_ssi_servicio_ssi_articulo_cat1`
    FOREIGN KEY (`serv_cat_id_fk`)
    REFERENCES `ssigdl`.`ssi_categoria` (`cat_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ssigdl`.`ssi_factura_articulo_rel`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ssigdl`.`ssi_factura_articulo_rel` ;

CREATE TABLE IF NOT EXISTS `ssigdl`.`ssi_factura_articulo_rel` (
  `fart_id` INT NOT NULL AUTO_INCREMENT,
  `fart_art_id_fk` INT NOT NULL,
  `fart_fact_id_fk` INT NOT NULL,
  PRIMARY KEY (`fart_id`),
  INDEX `fk_ssi_factura_articulo_rel_ssi_articulo1_idx` (`fart_art_id_fk` ASC),
  INDEX `fk_ssi_factura_articulo_rel_ssi_factura1_idx` (`fart_fact_id_fk` ASC),
  CONSTRAINT `fk_ssi_factura_articulo_rel_ssi_articulo1`
    FOREIGN KEY (`fart_art_id_fk`)
    REFERENCES `ssigdl`.`ssi_articulo` (`art_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ssi_factura_articulo_rel_ssi_factura1`
    FOREIGN KEY (`fart_fact_id_fk`)
    REFERENCES `ssigdl`.`ssi_factura` (`fact_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ssigdl`.`ssi_telefono_cat`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ssigdl`.`ssi_telefono_cat` ;

CREATE TABLE IF NOT EXISTS `ssigdl`.`ssi_telefono_cat` (
  `telc_id` INT NOT NULL AUTO_INCREMENT,
  `telc_descripcion` VARCHAR(100) NULL,
  PRIMARY KEY (`telc_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ssigdl`.`ssi_telefono`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ssigdl`.`ssi_telefono` ;

CREATE TABLE IF NOT EXISTS `ssigdl`.`ssi_telefono` (
  `tel_id` INT NOT NULL AUTO_INCREMENT,
  `tel_telefono` VARCHAR(16) NULL,
  `tel_telc_id_fk` INT NOT NULL,
  `tel_dire_id_fk` INT NOT NULL,
  PRIMARY KEY (`tel_id`),
  INDEX `fk_ssi_telefono_ssi_direccion_empresa1_idx` (`tel_dire_id_fk` ASC),
  INDEX `fk_ssi_telefono_ssi_telefono_cat1_idx` (`tel_telc_id_fk` ASC),
  CONSTRAINT `fk_ssi_telefono_ssi_direccion_empresa1`
    FOREIGN KEY (`tel_dire_id_fk`)
    REFERENCES `ssigdl`.`ssi_direccion_empresa` (`dire_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ssi_telefono_ssi_telefono_cat1`
    FOREIGN KEY (`tel_telc_id_fk`)
    REFERENCES `ssigdl`.`ssi_telefono_cat` (`telc_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ssigdl`.`ssi_factura_servicio_rel`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ssigdl`.`ssi_factura_servicio_rel` ;

CREATE TABLE IF NOT EXISTS `ssigdl`.`ssi_factura_servicio_rel` (
  `fase_id` INT NOT NULL AUTO_INCREMENT,
  `fase_serv_id_fk` INT NOT NULL,
  `fase_fact_id_fk` INT NOT NULL,
  PRIMARY KEY (`fase_id`),
  INDEX `fk_ssi_factura_servicio_rel_ssi_factura1_idx` (`fase_serv_id_fk` ASC),
  INDEX `fk_ssi_factura_servicio_rel_ssi_servicio1_idx` (`fase_fact_id_fk` ASC),
  CONSTRAINT `fk_ssi_factura_servicio_rel_ssi_factura1`
    FOREIGN KEY (`fase_serv_id_fk`)
    REFERENCES `ssigdl`.`ssi_factura` (`fact_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ssi_factura_servicio_rel_ssi_servicio1`
    FOREIGN KEY (`fase_fact_id_fk`)
    REFERENCES `ssigdl`.`ssi_servicio` (`serv_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ssigdl`.`ssi_categoria_temporal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ssigdl`.`ssi_categoria_temporal` ;

CREATE TABLE IF NOT EXISTS `ssigdl`.`ssi_categoria_temporal` (
  `catt_id` INT NOT NULL AUTO_INCREMENT,
  `catt_id_padre` INT NULL,
  `catt_id_hijo` INT NULL,
  `catt_nivel` INT NULL,
  PRIMARY KEY (`catt_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ssigdl`.`ssi_cheque`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ssigdl`.`ssi_cheque` ;

CREATE TABLE IF NOT EXISTS `ssigdl`.`ssi_cheque` (
  `che_id` INT NOT NULL AUTO_INCREMENT,
  `che_numero` VARCHAR(7) NULL,
  `che_fecha` DATE NULL DEFAULT '0001-01-01',
  `che_monto` DECIMAL(10,2) NULL DEFAULT 0.00,
  `che_receptor` VARCHAR(100) NULL,
  `che_concepto` VARCHAR(100) NULL,
  PRIMARY KEY (`che_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ssigdl`.`ssi_informacion_personal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ssigdl`.`ssi_informacion_personal` ;

CREATE TABLE IF NOT EXISTS `ssigdl`.`ssi_informacion_personal` (
  `infp_id` INT NOT NULL,
  `infp_nombre` VARCHAR(50) NULL,
  `infp_apellido` VARCHAR(50) NULL,
  `infp_sexo` SET('M', 'F') NULL,
  PRIMARY KEY (`infp_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ssigdl`.`ssi_usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ssigdl`.`ssi_usuario` ;

CREATE TABLE IF NOT EXISTS `ssigdl`.`ssi_usuario` (
  `usu_id` INT NOT NULL,
  `usu_codigo` VARCHAR(255) NULL,
  `usu_password` VARCHAR(255) NULL,
  `usu_fecha` DATE NULL,
  `usu_infp_id_fk` INT NOT NULL,
  PRIMARY KEY (`usu_id`),
  INDEX `fk_ssi_usuario_ssi_informacion_personal1_idx` (`usu_infp_id_fk` ASC),
  CONSTRAINT `fk_ssi_usuario_ssi_informacion_personal1`
    FOREIGN KEY (`usu_infp_id_fk`)
    REFERENCES `ssigdl`.`ssi_informacion_personal` (`infp_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `ssigdl`.`ssi_cheque`
-- -----------------------------------------------------
START TRANSACTION;
USE `ssigdl`;
INSERT INTO `ssigdl`.`ssi_cheque` (`che_id`, `che_numero`, `che_fecha`, `che_monto`, `che_receptor`, `che_concepto`) VALUES (1, '120', now(), 150, 'IBM', 'Equipos');
INSERT INTO `ssigdl`.`ssi_cheque` (`che_id`, `che_numero`, `che_fecha`, `che_monto`, `che_receptor`, `che_concepto`) VALUES (2, '121', now - INTERVAL 1 DAY, 250, 'Sanmina', 'Mesas');
INSERT INTO `ssigdl`.`ssi_cheque` (`che_id`, `che_numero`, `che_fecha`, `che_monto`, `che_receptor`, `che_concepto`) VALUES (3, '122', now - INTERVAL 2 DAY, 450, 'Dicesa', 'Carros');

COMMIT;

