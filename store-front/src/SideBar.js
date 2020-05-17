import React from 'react';
import { Card, CardActionArea, Container, Tooltip, makeStyles } from '@material-ui/core';
import SearchIcon from '@material-ui/icons/Search';

const useStyles = makeStyles(theme => ({
  container: {
    padding: theme.spacing(0)
  },
  searchIcon: {
    fontSize: 60
  },
  card: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    paddingRight: theme.spacing(0),
    width: 115,
    height: 115,
    border: '1',
    boxShadow: 'None'
  }
}));

export default function SideBar() {
  const styles = useStyles();
  
  // get data
  const testData = [
    {
      'name': 'test1'
    },
    {
      'name': 'test2'
    }
  ]
  
  return (
    <Container className={styles.container}>
      <Card className={styles.card}>
        <CardActionArea className={styles.card}>
          <Tooltip>
            <SearchIcon className={styles.searchIcon}/>
          </Tooltip>
        </CardActionArea>
      </Card>
      {testData.map(data => (
        <Card className={styles.card}>
          <CardActionArea className={styles.card}>
            {data.name}
          </CardActionArea>
        </Card>
      ))}
    </Container>
  );
}