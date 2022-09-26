package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

const (
	lichessBotID = "LICHESS_BOT"

	schemaVersion   = 1
	lichessBotLabel = "lichess bot"

	onlineMessage  = "online"
	offlineMessage = "offline"
	playingMessage = "playing"
	errorMessage   = "error"

	onlineColor  = "brightgreen"
	offlineColor = "red"
	playingColor = "blue"
	errorColor   = "red"
)

func handler(request events.APIGatewayProxyRequest) (*events.APIGatewayProxyResponse, error) {
	bot := os.Getenv(lichessBotID)

	status, err := botStatus(bot)
	if err != nil {
		s, _ := json.Marshal(shield(true, false, false))

		return &events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       string(s),
		}, err
	}

	s, _ := json.Marshal(shield(false, status.Online, status.Playing))

	return &events.APIGatewayProxyResponse{
		StatusCode: 200,
		Body:       string(s),
	}, nil
}

func main() {
	lambda.Start(handler)
}

func shield(isError, online, playing bool) shieldBody {
	switch {
	case isError:
		return shieldBody{schemaVersion, lichessBotLabel, errorMessage, errorColor}
	case online && playing:
		return shieldBody{schemaVersion, lichessBotLabel, playingMessage, playingColor}
	case online:
		return shieldBody{schemaVersion, lichessBotLabel, onlineMessage, onlineColor}
	default:
		return shieldBody{schemaVersion, lichessBotLabel, offlineMessage, offlineColor}
	}
}

type shieldBody struct {
	SchemaVersion int    `json:"schemaVersion"`
	Label         string `json:"label"`
	Message       string `json:"message"`
	Color         string `json:"color"`
}

func botStatus(id string) (*statusResponse, error) {
	res, err := http.Get("https://lichess.org/api/users/status?ids=" + id)
	if err != nil {
		return nil, err
	}
	defer res.Body.Close()

	var statuses []statusResponse
	if err := json.NewDecoder(res.Body).Decode(&statuses); err != nil {
		return nil, err
	}

	if len(statuses) == 0 {
		return nil, fmt.Errorf("lichess id %s not found", id)
	}

	return &statuses[0], nil
}

type statusResponse struct {
	ID        string `json:"id"`
	Name      string `json:"name"`
	Title     string `json:"title"`
	Online    bool   `json:"online"`
	Playing   bool   `json:"playing"`
	Streaming bool   `json:"streaming"`
	Patron    bool   `json:"patron"`
}
