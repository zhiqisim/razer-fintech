import React from 'react';
import { Typography, makeStyles } from '@material-ui/core';
import { Container, Row, Col } from 'react-bootstrap';
import LocationOnIcon from '@material-ui/icons/LocationOn';

const useStyles = makeStyles(theme => ({
  logoContainer: {
    padding: 0,
    display:'flex',
    flexDirection: 'row',
    alignItems:'center',
  },
  logo: {
    height: 50,
    alignItems: 'center',
    justifyContent: 'center',
    paddingRight: 1,
    paddingLeft: 0,
    marginLeft: theme.spacing(2)
  },
  topbar: {
    height: 110, 
    width: '100%',
    padding: 0,
    backgroundColor: 'transparent',
    boxShadow: 'none'
  },
  locationicon: {
    display: 'flex',
    alignItems: 'center'
  },
  icon: {
    fontSize: 25,
    color: 'grey'
  }, 
  address: {
    padding: theme.spacing(1),
    display: 'flex',
    alignItems: 'center',
    paddingRight: theme.spacing(2),
  },
  row1: {
    paddingTop: theme.spacing(1),
    paddingLeft: theme.spacing(2),
    alignItems: 'center'
  },
  row2: {
    paddingLeft: theme.spacing(12),
    alignItems: 'center',
    marginBottom: theme.spacing(2)
  },
  storename: {
    paddingRight: theme.spacing(2),
    marginLeft: theme.spacing(2),
    alignItems: 'center',
    fontSize: 40,
    color: 'black'
  },
  address: {
    color: 'grey',
    fontSize: 15
  }
}));

export default function TopBar(data) {
  const styles = useStyles();

  const storeName = data.name;
  const address = data.address;
  
  return (
    <Container className={styles.topbar}>
      <Row className={styles.row1}>
        <img src={data.logo} alt='logo' className={styles.logo}/>
        <Typography variant="h6" className={styles.storename}>
          {storeName}
        </Typography>
      </Row>
      <Row className={styles.row2}>
        <LocationOnIcon className={styles.icon}/>
        <Typography className={styles.address}>
          {address}
        </Typography>
      </Row>
    </Container>
  );
}