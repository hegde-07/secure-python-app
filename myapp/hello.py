import requests

def main():
    print("Hello from Secure Python App!")
    response = requests.get("https://httpbin.org/get")
    print(response.json())

if __name__ == "__main__":
    main()
