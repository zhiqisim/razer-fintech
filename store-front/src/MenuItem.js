import React from 'react';
import { Button, Card, Container, CardActionArea, IconButton, Typography, makeStyles } from '@material-ui/core';
import AddShoppingCartIcon from '@material-ui/icons/AddShoppingCart';
import PaymentIcon from '@material-ui/icons/Payment';
import { Row, Col } from 'react-bootstrap';
import Popup from "reactjs-popup";

const useStyles = makeStyles(theme => ({
  card: {
    display: 'flex',
    alignItems: 'center',
    paddingRight: theme.spacing(0),
    width: 340,
    height: 120,
    border: '1',
  },
  image: {
    width: 70,
    height: 100
  },
  purchase: {
    width: 200,
    height: 250,
  },
  purchaseImg: {
    width: 70,
    height: 100
  },
  iconRow: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    paddingTop: theme.spacing(1),
    paddingBottom: theme.spacing(1)
  }
}));

export default function MenuItem(data) {
  const styles = useStyles();
  let storeId = data.data.storeId;
  console.log(data)
  
  const purchaseItem = () => {
    let response = {
      'Storename': data.data.data.name,
      'items': [
      ],
    }
    
    fetch(
      'http://ec2-13-250-45-244.ap-southeast-1.compute.amazonaws.com/store/' + storeId,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(response)
      },
    ).then(reponse => {
      alert('Success! Redirecting to your new store!');
      window.location.href = 'http://f2d8405a.ngrok.io/view/' + storeId; 
    }).catch(error => {
      console.log(error);
    });
  }
  
  
  return (
    
    <Popup trigger={
      <Card className={styles.card}>
        <CardActionArea className={styles.card}>
          <Col>
            <Typography variant='h6'>
              {data.name}
            </Typography>
            <Typography variant='overline'>
              {data.price}
            </Typography>
          </Col>
          <Col>
            <img src={require("./images/bbt.jpg")} className={styles.image}/>
          </Col>
        </CardActionArea>
      </Card>
    } position="center center">
      <div className={styles.purchase}>
        <Container>
          <Row className={styles.iconRow}>
            <img src={require("./images/bbt.jpg")} className={styles.purchaseImg}/>
          </Row>
          <Row className={styles.iconRow}>
            <Typography variant='h6'>
              {data.name}
            </Typography>
          </Row>
          <Row className={styles.iconRow}>
            <Typography>
              {data.price}
            </Typography>
          </Row>
          <Row className={styles.iconRow}>
            <IconButton color="black" aria-label="add to shopping cart">
              <AddShoppingCartIcon />
            </IconButton>
            <a href='https://light.microsite.perxtech.io/game/1?token=2ec70d7963e3fde9930c147c884139bc3e88d8c294c3d02b90b9de79185529e4&redirect_uri=:optional_url'>
              <IconButton color="black" aria-label="buy" onClick={purchaseItem}>
                <PaymentIcon />
              </IconButton>
            </a>
          </Row>
          <Typography>
          </Typography>
        </Container>
      </div>
    </Popup>
  );
}